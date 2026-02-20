package web.html.xtend

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.http.*
import org.apache.poi.ss.usermodel.WorkbookFactory
import java.io.File

fun main() {
    embeddedServer(Netty, port = 8080) {
        routing {
            get("/paperweb") {
                // 1. Load your Excel file (Make sure paper.xlsx exists in your root folder!)
                val file = File("paper.xlsx")
                val htmlTable = if (file.exists()) {
                    val workbook = WorkbookFactory.create(file)
                    val sheet = workbook.getSheetAt(0)
                    val sb = StringBuilder("<table class='paper-table'>")
                    
                    for (row in sheet) {
                        sb.append("<tr>")
                        for (cell in row) sb.append("<td>$cell</td>")
                        sb.append("</tr>")
                    }
                    sb.append("</table>").toString()
                } else {
                    "<h2>Please add 'paper.xlsx' to your project folder!</h2>"
                }

                // 2. Send the Paper-styled HTML
                call.respondText("""
                    <html>
                    <head>
                        <style>
                            body { 
                                background: #fdfaf0; /* Paper color */
                                background-image: url('https://www.transparenttextures.com'); 
                                font-family: 'Courier New', Courier, monospace;
                                padding: 50px;
                            }
                            .paper-table { 
                                border-collapse: collapse; 
                                margin: auto; 
                                background: white; 
                                box-shadow: 5px 5px 15px rgba(0,0,0,0.1); 
                            }
                            td { border: 1px solid #ddd; padding: 15px; color: #444; }
                            tr:nth-child(even) { background: #fafafa; }
                        </style>
                    </head>
                    <body>
                        <h1>PaperWeb Explorer</h1>
                        $htmlTable
                    </body>
                    </html>
                """.trimIndent(), ContentType.Text.Html)
            }
        }
    }.start(wait = true)
}
