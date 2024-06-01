import Flutter
import UIKit
import CoreML

let ModelUrl = "https://platbook-images.s3.eu-west-3.amazonaws.com/PlatTypeTag.mlmodel"
let ModelName = "PlatTypeTag.mlmodel"

public class MiccoPlatbookTaggingPlugin: NSObject, FlutterPlugin {
  private var model: MLModel?;

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "micco_platbook_tagging", binaryMessenger: registrar.messenger())
    let instance = MiccoPlatbookTaggingPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private func loadModel () {
    guard let url = URL(string: ModelUrl) else {return}
    downloadModel(from: url) { (url, err) in
      if let error = err {
        print(error)
      }
    }
  }

  private func predict (_ input: String) -> String? {
    do {
      if (self.model == nil) {
        guard let documentUrl = getDocumentDir() else { return nil}
        guard let url = URL(string: "\(documentUrl)/\(ModelName)") else { return nil}
        let compiledModelURL = try MLModel.compileModel(at: url)
        self.model = try MLModel(contentsOf: compiledModelURL)
      }
      guard let modell = self.model else { return nil }
      let input = MLFeatureValue(string: input)
      let modelInput = try MLDictionaryFeatureProvider(dictionary: ["text": input, "confidence": 0.0])
      let result = try modell.prediction(from: modelInput)
      print(String(describing: result.featureValue(for: "confidence")))
      if let featureVal = result.featureValue(for: "label") {
        return featureVal.stringValue
      }
      return nil
    } catch {
      print(error)
      return nil
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "loadLodel":
      loadModel()
      result(nil)
    case "predict":
      if let args = call.arguments as? Dictionary<String, Any>,
        let key = args["key"] as? String {
          // print("key: \(key)")
          result(predict(key))
        } else {
          // print("args: \(String(describing: call.arguments))")
          result(nil)
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

func downloadModel(from url: URL, completion: @escaping (URL?, Error?) -> Void) {
  // Create a URLSession
  let session = URLSession(configuration: .default)

  // Create a download task
  let downloadTask = session.downloadTask(with: url) { (tempURL, response, error) in
    if let error = error {
      print("Download error: \(error)")
      completion(nil, error)
      return
    }
    
    // Ensure the temporary file URL is valid
    guard let tempURL = tempURL else {
      print("Invalid temporary file URL")
      completion(nil, nil)
      return
    }

    // Get the destination URL (Documents directory)
    do {
      let manager = FileManager.default
      let documentsURL = getDocumentDir()
      guard let documentUrl = documentsURL else {return}
      let destinationURL = documentUrl.appendingPathComponent(ModelName)

      // Move the downloaded file from temporary URL to the destination URL
      try manager.moveItem(at: tempURL, to: destinationURL)
      print("File saved to: \(destinationURL)")

      // Call the completion handler with the destination URL
      completion(destinationURL, nil)
    } catch {
      print("File error: \(error)")
      completion(nil, error)
    }
  }

  // Start the download task
  downloadTask.resume()
}

func getDocumentDir () -> URL? {
  let manager = FileManager.default
  return try? manager.url(
    for: .documentDirectory,
    in: .userDomainMask,
    appropriateFor: nil,
    create: false
  )
}

