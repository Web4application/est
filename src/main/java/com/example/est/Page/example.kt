package com.example.est

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun main() {
    embeddedServer(Netty, port = 8080) {
        routing {
            get("/") {
                call.respondText("Hello! Your Kotlin Web Server is running at com.example.est")
            }
            get("/web/est") {
                call.respondText("Welcome to the web.est endpoint!")
            }
        }
    }.start(wait = true)
}
