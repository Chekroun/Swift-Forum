import Kitura
import KituraStencil

let router = Router()

router.all(middleware: [BodyParser(), StaticFileServer(path: "./Public")])
router.add(templateEngine: StencilTemplateEngine())

router.get("/") { request, response, next in
    try response.render("Home.stencil", context: [:])
	next()
}

router.get("/forum/:subject") { request, response, next in
    let subject = request.parameters["subject"] ?? "Unknown Probable Biped"
    try response.render("Forum.stencil", context: ["subject" : subject])
    next()
}

struct HelloParams : Codable {
    let name: String
}

struct HelloResponse : Codable {
    let result: String
}

func handleCodableHello(input: HelloParams, output: (HelloResponse?, RequestError?)->Void) {
    output(HelloResponse(result: "Hello \(input.name)"), nil) // no error
}

router.post("/api/chello", handler: handleCodableHello)

router.get("/shello/:subject") { request, response, next in
    let subject = request.parameters["subject"] ?? "Unknown Probable Biped"
    try response.render("Hello.stencil", context: ["subject" : subject])
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
