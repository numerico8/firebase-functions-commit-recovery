//PACKAGES
import * as functions from 'firebase-functions';
import admin = require('firebase-admin');
import {Stripe} from 'stripe';
import https = require('https');
import encrypt = require('md5');
const firestore = require('@google-cloud/firestore');
const client = new firestore.v1.FirestoreAdminClient();

// BUCKET_NAME TO DO THE DAILY BACKUP
const bucket = 'gs://pimpineo-a818d';

// initial configuration of the admin SDK
admin.initializeApp(functions.config());

//including stripe and these are the data that system is requiring this is subject to future updates since the APIs are updated as well 
const stripe = new Stripe(functions.config().key.secret , {apiVersion: '2020-03-02', typescript: true});
  

/* *Function to write in the database the new registered 
   *At the same time this function creates a stripe customer and saves its id in Firestore database
*/
export const createFirestoreUser = functions.https.onCall(async (data) => {

        console.log('Creating new user: '+data['uid']); //show that the function was called to create new user 

        //stripe creation of a customer with th email as soon as the user is registering the first time
        //creating the customer in stripe
        const stripe_customer = await stripe.customers.create({
            name : data['nombre'],
            email : data['correo'],
            phone : data['telefono'],
        })

        const customer_id = stripe_customer.id;
         
        console.log(stripe_customer.id);  //show the new new customer stripe_id created
               
        
        try { 
        // object to pass to the user when created in the system
        /**Update customer stripe_id after creted in Stripe API*/
            const payments = {
                stripe_id : customer_id,
                payment_methods : [],
                payment_in_process : {},
            } //check how to update only one field in firestore 



        // creating the customer in firestore
            await admin.firestore().collection('users').doc(data['uid']).set({
                'uid' : data['uid'],
                'credito' : data['credito'],
                'pais' : data['pais'],
                'telefono' : data['telefono'],
                'correo' : data['correo'],
                'nombre' : data['nombre'],
                'payments' : payments,
                'contactos' : data['contactos'],
                'accepted_termsAndCond': data['termsAndCond'],
                'transaction_records' : []
            },{merge : true}).then((val)=>{
                console.log(val.writeTime + 'User succesfully created.') //if the user was created succesfully
                return 'successfull'
            }).catch(async (e) => {
                console.log('Error creating the user: ' + e) //show if there was an error creting the firestore user
                await stripe.customers.del(customer_id)
                return 'error'
            });

            return customer_id
 
        } catch (error) {
            console.log('Error in the main function to create user: ' + error); //show if there was an error in the function in general 
            await stripe.customers.del(customer_id)
            return 'function error'
        }
        
});


// this is directly updtaing the user in the application local then calls this function and delete contact in the firestore
export const updateContactList = functions.https.onCall(async (data) => {
    console.log('Update contact list requested: '+data['uid']); //show that a contact list update was requested to delete or add users
    const result = admin.firestore().collection('users').doc(data['uid']).update({
        'contactos' : data['contactos'],
    })
    .catch((e) => {
       console.log('Error updating the contacts list: ' + e);
       return 'error';
    }); 
    return result;
});


// this is the to make a payment with a credit card Stripe API comunication inside
export const makePaymentCard = functions.https.onCall(async (data) => {

    console.log('Make a payment function requested: '+data['uid']); //Show that the function to make a payment is running***************

    try {

      const newCredit = (parseFloat(data['amount'])/100) + parseFloat(data['credito'])
      
      console.log((parseFloat(data['amount'])/100).toFixed(2)) //shows amount to charge*****************************

      let paymentMethod;

      if(data['isSavedCard']){
          //saved payment method 
          paymentMethod = (await stripe.paymentMethods.retrieve(data['paymentID']))
      }
      else{
         //new payment method
         //create an card token
         const cardToken = await stripe.tokens.create({
           card : {
               //this is the parameters that are most important
               number : data['number'],
               exp_month : data['exp_month'],
               exp_year : data['exp_year'],
               cvc : data['cvc'],
           }
         })

         
         //create payment method
         paymentMethod = await stripe.paymentMethods.create({
             type : 'card',
             card : {
                 token : cardToken.id
             },
         })
       
         //attach payment method
         await stripe.paymentMethods.attach(paymentMethod.id,{
             customer : data['stripe_id']
         })
      }
      
      //idempotency key
      const idemKey = encrypt(Date.now()+data['stripe_id'])

      console.log(idemKey); //show the idemkey for that transaction ***************************

      //creating actual payment
      const payment = await stripe.paymentIntents.create({
          amount : (Number(Number(data['amount']).toFixed(0))),
          currency : 'usd',
          capture_method : data['capture'] === true ? "automatic" : "manual",
          customer : data['stripe_id'],
          payment_method : paymentMethod.id,
          confirm : true,
      }, {idempotencyKey : idemKey})

      
      console.log('Payment Created'); //show the payment sent to stripe for that transaction ******************


      //Compra de Credito Record por esa razon ponemos el campo de credito en el record y el metodo de pago
      const newRecord = {
          'type' : data['type'], 
          'cantidad' : data['amount']/100, 
          'timestamp' : payment.created,
          'credito': data['credito'],
          'payment_id' : payment.id,
          'payment_method' : payment.payment_method,
          'card_fingerprint' : paymentMethod.card?.fingerprint,
          'payment_status' : payment.status,
          'idemKey' : idemKey,
      } 
      
  
          if(data['savecard'] === true){  //customer requested to save the card on file

              //create the new objects that are going to be saved in firestore
               const savedCards = await stripe.paymentMethods.list({
                   customer : data['stripe_id'],
                   type : 'card',               
               })
              
              //write all new data in firestore with card included
              const saveCard = await admin.firestore().collection('users').doc(data['uid']).set({
                  'payments' : {
                      'payment_methods' : savedCards.data,
                      'payment_in_process' : payment
                  },
                  'credito' : data['capture'] === true ? newCredit : data['credito'],
                  //si la trasaccion fue mandada a capturar desde el inicio porque lo que se esta comprando es credito entinces pone el record de las transacciones desde aqui
                  'transaction_records' : data['capture'] === true ? admin.firestore.FieldValue.arrayUnion(newRecord) : data['listadoDeTransacciones'],
              },{merge : true})

              console.log(saveCard); //Firestore object
              
              if(saveCard.writeTime.valueOf() !== null){
                  console.log('Transaction succesfull.');
                  return true;
              }
              else{
                  console.log('There has been an error saving the data in Firestore')
                  return false
              }
          }
          else{  

              //meaning do not save card             
              if(data['isSavedCard'] === false){await stripe.paymentMethods.detach(paymentMethod.id)}

                            
              //write all new data in firestore with cards not included
              const saveCard = await admin.firestore().collection('users').doc(data['uid']).set({
                  'payments' : {
                      'payment_in_process' : payment
                  },
                  'credito' : data['capture'] === true ? newCredit : data['credito'],
                  'transaction_records' : data['capture'] === true ? admin.firestore.FieldValue.arrayUnion(newRecord) : data['listadoDeTransacciones'],
              },{merge : true})

              console.log(saveCard); //Firestore object
              
              if(saveCard.writeTime.valueOf() !== null){
                  console.log('Transaction succesfull.');
                  return true;
              }
              else{
                  console.log('There has been an error saving the data in Firestore.')
                  return false
              }
          }

    } catch (error) {
        console.log('There was an error in the function to makePayment.')
        console.log(error)
        return false;
    }

})


//this is the step to capture the payment charge
export const processPaymentCard = functions.https.onCall(async (data) => {
    /**Toma el ultimo record de pago de este  uid y lo pasa en la data lo que significa que este es el 
     * ID del cargo que va a ser cobrado ademas se pasa el nuevo amount en la data y ahi se cobra */

    console.log('Process payment was called since the RECHARGE was succesfully sent: ' + data['uid']); //show that paymnet is being processed

    try {
        
        let payment:any

        function updateList(datax:any){
            payment = datax.payments.payment_in_process
            console.log(payment['id']) //show the payment that is being processed for this uid*******************
        }
        
        await admin.firestore().collection('users').doc(data['uid']).get().then(doc => {
            if(!doc.exists){
                console.log('Document doesnt exist.') //doc doesnt exist **************
            }else{
                updateList(doc.data())
            }
        })


        if(payment['status'] === "requires_capture"){

          console.log('Capture required: '+payment['status']) //shows the status of the payment*******************
          console.log('Amount to capture: '+payment['amount']/100) //shows the amount to capture*******************

          const capturedPayment = await stripe.paymentIntents.capture(
              payment['id'], {amount_to_capture : (Number(Number(data['amount']).toFixed(0))),},
          )

          console.log(capturedPayment.status) //show status of the captured payment *************************

        //this is to create the record
          if(capturedPayment.status !== 'succeeded'){
              console.log(capturedPayment.status)
              return capturedPayment.status;
          }else{
            
            console.log('Captured Payment: '+ payment['id']) //shows the status of the payment
            //los telefonos recargados se les va a pasar por la data y crea un string que se va a porner para mostrar en el record
              let telefonosRecargadosString = ''
              const telefonosRecargados: any[] = data['telefonosRecargados']
              telefonosRecargados.forEach((value)=>{
                  telefonosRecargadosString = telefonosRecargadosString + value['telefono'].toString() +', '
              })              
              

              //create the record for a transaction paid with card or paid with card and app  credit
              const newRecord = {
                'type' : data['type'], 
                'cantidad' : payment['amount']/100,
                'timestamp' : capturedPayment.created,
                'payment_method' : capturedPayment.payment_method,//response.payment_method_details?.card?.last4, 'fingerprint' : payment['payment_method_details']['card']['fingerprint'],//response.payment_method_details?.card?.fingerprint,
                'payment_id' : capturedPayment.id, //response.id,
                'telefonosRecargadosString' :  telefonosRecargadosString, //para mostrar en el record 
                'telefonosRecargados' : telefonosRecargados // para guardar para posibles futuras recargas
              }
              
              const record = await admin.firestore().collection('users').doc(data['uid']).set({
                'transaction_records' : admin.firestore.FieldValue.arrayUnion(newRecord)
              },{merge : true})
              

              if(record.writeTime.valueOf() === null){
                  console.log('There has been an error saving the data in Firestore')
              }

              console.log('charge has been captured successfully') 
              return 'charge has been captured successfully'
          }
        }else{
          console.log('No charge to capture')
          return 'no charge to capture'
        }
        
    } catch (error) {
        console.log('Error running the cloud function.' + error.message)
        return 'Error running the cloud function.'
    }
    
    
})

 
// this is the function comunicating with DT One API recharge 
export const enviarRecarga = functions.https.onCall(async (data) => {

    console.log('Function enviarRecarga requested: ' + data['telefono']) //show that the function is running
    /*
      la data que entra en esta function esta escrita como sigue: json file con los contactos que se requiere recargar ademas de
      los datos del usuario que esta enviando la recarga.
      La data que esta viniendo es un json file que tiene que ser enviado como xml al API de DT One.
    */

    // create encryption md5 using the key as Date now plus the phone number to be reloaded
    const APILogin = 'nationalconnection'
    const token = 'iMAO8vowC0AlH';
    const the_key_as_number = Date.now() + Number.parseInt(String(data['telefono']).replace('+','')); //telefono of the user that is sending the recharge
    const the_key_as_string = String(the_key_as_number);
    const tomd5 = APILogin + token + the_key_as_string  // we have the login and the account token
    const md5_variable = encrypt(tomd5);
    const telefonoLimpio = String(data['telefono']).replace(' ','').replace('-','').replace('(','').replace(')','');

    console.log('Telefono limpio: ' + telefonoLimpio) //show that the function is running

        
    const url = 'https://airtime-api.dtone.com/cgi-bin/shop/topup?login='+APILogin+'&key='+the_key_as_string+'&md5='+md5_variable+'&action=msisdn_info&destination_msisdn='+telefonoLimpio
  
    console.log(url) //show the url that was created for the request
    
     try {

        let response_body = ''
        let result = ''
        
        //funcion donde se hace la comunicacion con la API que te devuelve si la comunicacion fue exitosa o no
        function httpsRequest(path:string){
            return new Promise((resolve) => https.get(path, (response) => {
                response.on('data', (chunk) => {
                   //console.log(chunk.toString()); 
                   response_body = chunk.toString();
                }).on('end',()=>{
                if(response_body.includes('Transaction successful') === true){
                    result = 'Transaction successful'
                    resolve(result)
                } 
                else{
                    result = 'Transaction failed'
                    resolve(result)
                } 
                })
            }).end())
        }
        
        const finalResult = await httpsRequest(url) 
        console.log('Response from API DT ONE: '+finalResult) //shows the reponse from the API DT ONE
           
        return finalResult
        
     } catch (error) {
        console.log('There was an error with the function to recharge: '+error) //show the error
        return 'Error'
     }

})

//this is the function to delete any payment method in stripe and firestore as per cusotmer request
export const deletePaymentMethod = functions.https.onCall(async (data) => {

    console.log('Delete Payment Method function running: '+data['uid']) //show that the function is running
  
try {
    
   await stripe.paymentMethods.detach(data['pmID'])

   const savedCards = await stripe.paymentMethods.list({
       customer : data['stripe_id'],
       type : 'card',               
   })

   await admin.firestore().collection('users').doc(data['uid']).set({
       'payments' : {
           'payment_methods' : savedCards.data
       }
   },{merge:true})
   
   console.log('Payment Method deleted succedfully.')
   return true;

} catch (error) {
    console.log('There was an error in the function: '+error)
    return false;        
}
   
})

//function that set up and schedule daily backup
export const scheduleFirestoreExport = functions.pubsub.schedule('every 24 hours').onRun((context) => {
    console.log('Backup running'); // show that the back up is running
    const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;
    const databaseName = client.databasePath(projectId, '(default)');
  
    return client.exportDocuments({
      name: databaseName,
      outputUriPrefix: bucket,
      // Leave collectionIds empty to export all collections
      // or set to a list of collection IDs to export,
      // collectionIds: ['users', 'posts']
      collectionIds: []
      })
    .then((responses: any[]) => {
      const response = responses[0];
      console.log(`Operation Name: ${response['name']}`);
    })
    .catch((err: any) => {
      console.error(err);
      throw new Error('Export operation failed');
    });
})











