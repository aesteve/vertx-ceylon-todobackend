import io.vertx.ceylon.web { ... }
import io.vertx.ceylon.core { Verticle,
    Future }
import io.vertx.ceylon.core.http { HttpServer }
import todobackend.routing {
    TodoRouter
}

shared class Server() extends Verticle() {

	variable HttpServer? server = null;

	shared actual void startAsync(Future<Anything> future) {
		server = vertx.createHttpServer()
			.requestHandler(TodoRouter(vertx).handler)
			.listen(8181, future.completer());
	}

	shared actual void stopAsync(Future<Anything> future) {
		if (exists httpServer = server) {
			httpServer.close(future.completer());
		} else {
			future.complete();
		}
	}

}
