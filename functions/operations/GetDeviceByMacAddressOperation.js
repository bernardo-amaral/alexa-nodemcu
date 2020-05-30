const serviceAccount = require("../permissions.json");
const admin = require('firebase-admin');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: process.env.DB_HOST
});

const db = admin.firestore();
const devicesCollection = db.collection('devices');
const CreateDeviceOperation = require("CreateDeviceOperation");

class GetDeviceByMacAddressOperation {
    static async execute(deviceMacAddress) {
        try {
            const document = devicesCollection.doc(deviceMacAddress);
            let item = await document.get();
            let deviceData = item.data();
            if (!deviceData) {
                const receipt = {
                    name: request.body.name,
                    mac_address: request.body.mac_address,
                    on: false,
                    updated: (new Date()).toString()
                };
                let createResponse = await CreateDeviceOperation.execute(receipt);
                return { createResponse };
            }
            return { deviceData };
        } catch (error) {
            return { error };
        }
    }
}

module.exports = GetDeviceByMacAddressOperation;