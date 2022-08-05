import Foundation

struct MultipartFormDataRequest {
    
    //set up some variables
    private let boundary: String = UUID().uuidString
    private var httpBody = NSMutableData()
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    //adding text field function
    func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value))
        
    }
    
    private func textFormField(named name: String, value: String) -> String {
        
        //define textfield style to be uploaded
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    //adding data field function
    func addDataField(named name: String, data: Data, mimeType: String) {
        httpBody.append(dataFormField(named: name, data: data, mimeType: mimeType))
    }
    
    private func dataFormField(named name: String, data: Data, mimeType: String) -> Data {

        //define data field style to be uploaded
        let fieldData = NSMutableData()
        
        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")
        
        return fieldData as Data
    }
    
    //set up URL request
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        
        //decalre the type of http interaction
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //perform the request
        httpBody.append("--\(boundary)--")
        request.httpBody = httpBody as Data
        return request
    }
    
}

//creating an extension to a class (created by apple) to allow appending of data
extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

//creating an extension to a class (created by apple) to allow a specific type of URL session that we need
extension URLSession {
    func dataTask(with request: MultipartFormDataRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask {
        
        return dataTask(with: request.asURLRequest(), completionHandler: completionHandler)
    }
}


