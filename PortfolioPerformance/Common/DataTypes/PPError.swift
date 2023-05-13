enum PPError: String, Error {
    
    case netwokingError = "Server is not responding"
    case decodingError = "Requests per minute limit reached, please try again later"
    case invalidUrl = "The requested URL is invalid"
    case invalidData = "Invalid data from the server"
}
