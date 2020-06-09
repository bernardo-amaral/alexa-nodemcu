const admin = require('firebase-admin');
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