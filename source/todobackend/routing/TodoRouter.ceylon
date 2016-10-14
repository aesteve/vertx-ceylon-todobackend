import io.vertx.ceylon.core.http {
	HttpServerRequest,
    put,
    get,
    post,
    delete,
    patch
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

class TodoRouter(Vertx vertx) {

	value router_ = router.router(vertx);
	value writeMethods = [post, put, patch];
	value cors = corsHandler.create("*")
					.allowedHeader(HttpHeaders.contentType.string)
					.allowedMethod(get)
					.allowedMethod(delete);
	writeMethods.fold(cors.allowedMethod);
	value body = bodyHandler.create();

	shared Callable<Anything, [HttpServerRequest]> handler = router_.accept;

	void addContentType(RoutingContext ctx) {
		ctx.response().putHeader("content-type", "application/json");
		ctx.next();
	}

	void sendPayload(RoutingContext ctx) {
		ctx.response().end("todo");
	}

	/* Generic json */
	router_.route("/todos/*").handler(cors);
	// writeMethods.fold(m => router_.route(m, "/todos/*").handler(body));
	router_.route("/todos/*").handler(body);
	router_.route("/todos/*").handler(addContentType);
	router_.route("/todos/*").last().handler(sendPayload);

	/* TodoService related */
	// TODO
}
