const serviceAccount = require("../permissions.json");
const admin = require('firebase-admin');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: process.env.DB_HOST
});

const db = admin.firestore();

const CreateDeviceOperation = require("../operations/CreateDeviceOperation");
const GetDeviceByMacAddressOperation = require("../operations/GetDeviceByMacAddressOperation");

class DefaultController {

  static async createDevice(request, response) {
    const receipt = {
      name: request.body.name,
      mac_address: request.body.mac_address,
      on: false,
      updated: (new Date()).toString()
    };
    const { deviceData, error } = await CreateDeviceOperation.execute(receipt);

    if (error)
      return response.status(500).json({ message: error });

    return response.status(200).json(deviceData);
  }

  static async getDeviceByMacAddress(request, response) {
    const { device_mac } = request.params;
    const { deviceData, error } = await GetDeviceByMacAddressOperation.execute(device_mac);

    if (error)
      return response.status(500).json({ message: error });

    return response.status(200).json(deviceData);
  }

}

module.exports = DefaultController;