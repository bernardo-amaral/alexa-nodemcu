const serviceAccount = require("../permissions.json");
const admin = require('firebase-admin');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: process.env.DB_HOST
});

const db = admin.firestore();
const devicesCollection = db.collection('devices');

class CreateDeviceOperation {

    static async execute(device) {
        try {
            const deviceData = await devicesCollection.doc('/' + device.mac_address + '/')
                .create({
                    name: device.name,
                    mac_address: device.mac_address,
                    on: device.on,
                    updated: device.updated
                });
            return { deviceData };
        } catch (error) {
            return { error };
        }
    }
}

module.exports = CreateDeviceOperation;