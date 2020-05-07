import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const fcm = admin.messaging();

export const sendToTopic = functions.firestore.document('heroes/{heroId}').onCreate(async snapshot => {

    const hero = snapshot.data();

    const payLoad: admin.messaging.MessagingPayload = {
        notification: {
            title: 'New Hero!',
            body: `${hero ? hero.heroName : ''} is now onboard`,
            icon: 'https://lh3.googleusercontent.com/proxy/chaaDgYsZZTZAZRfUhrQGnKq6gGIuHAismnCmRh4kDGdmH5O6ZuBmtCBbgfje6wKb5khpYPrlS13tI_wiRYFlXs9OajvY9vnuuwY8P8X8LjLS8pIt84_VbW1vCzcUId5P9cl7i0IiXPX8R4aOPWjAg',
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
        
    };

    return fcm.sendToTopic('heroes', payLoad);
});