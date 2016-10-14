import io.vertx.ceylon.core.http {
	HttpServerRequest,
    put,
    get,
    post,
    delete,
    patch,
    HttpMethod
}
import io.vertx.ceylon.core { Vertx }
import io.vertx.ceylon.web { router, RoutingContext }
import io.vertx.ceylon.web.handler {
    corsHandler,
    bodyHandler
}
import io.vertx.core.http {
    HttpHeaders
}

shared class TodoRouter(Vertx vertx) {

	value router_ = router.router(vertx);
	value usingBody = [post, put, patch];
	value methods = usingBody.append([get, delete]);
	value body = bodyHandler.create();
	value cors = corsHandler.create("*")
					.allowedHeader(HttpHeaders.contentType.string)
					.allowedMethod(get)
					.allowedMethod(delete);
	methods.fold(cors.allowedMethod);

	shared Callable<Anything, [HttpServerRequest]> handler = router_.accept;

	void addContentType(RoutingContext ctx) {
		ctx.response().putHeader("content-type", "application/json");
		ctx.next();
	}

	void sendPayload(RoutingContext ctx) {
		ctx.response().end("todo");
	}

	void attachBodyHandler(HttpMethod method) {
		router_.route(method, "/todos/*").handler(body);
	}

	/* Generic json */
	usingBody.fold(attachBodyHandler);
	router_.route("/todos/*").handler(cors);
	router_.route("/todos/*").handler(addContentType);
	router_.route("/todos/*").last().handler(sendPayload);

	/* TodoService related */
	// TODO
}
