import PerfectLib

class Router {
	static func CreateRoutes() {
		
		let mainController = MainController()
		
		Routing.Handler.registerGlobally()
		
		Routing.Routes["GET", ["/", "index.html"] ] = Request.handle(mainController.getHomePage)
		Routing.Routes["GET", "/test"] = Request.handle(mainController.testRequest)
		Routing.Routes["GET", ["/user/{id}", "/user/{id}/{firstName}/{lastName}"]] = Request.handle(mainController.getUser)
		Routing.Routes["POST", "/user/{id}/baz"] = Request.handle(mainController.addUser)
		
		// Check the console to see the logical structure of what was installed.
		print("\(Routing.Routes.description)")
	}
}

private struct HandlerWrapper: RequestHandler {
	
	var handlerFunction: ((request: WebRequest, resonse: WebResponse) -> Void)
	
	init(function: (WebRequest, WebResponse) -> Void) {
		self.handlerFunction = function
	}
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		handlerFunction(request: request, resonse: response)
		response.requestCompletedCallback()
	}
}

private struct Request {
	static func handle(function: (WebRequest, WebResponse) -> Void) -> RequestHandlerGenerator {
		return { (_:WebResponse) in HandlerWrapper(function: function) }
	}
}
