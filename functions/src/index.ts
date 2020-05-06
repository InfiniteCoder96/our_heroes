import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const fcm = admin.messaging();

export const sendToTopic = functions.firestore.document('heroes/{heroId}').onCreate(async snapshot => {

    const hero = snapshot.data();

    const payLoad: admin.messaging.MessagingPayload = {
        notification: {
            title: 'New Hero!',
            body: `${hero ? hero.heroName : ''} is onboard`,
        }
        
    };

    return fcm.sendToTopic('heroes', payLoad);
});