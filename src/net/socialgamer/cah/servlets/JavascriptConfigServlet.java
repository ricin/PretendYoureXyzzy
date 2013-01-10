package net.socialgamer.cah.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class JavascriptConfigServlet extends HttpServlet {

  private static final long serialVersionUID = 4287566906479434127L;

  private String configString, configString2;

  @Override
  public void init(final ServletConfig config) throws ServletException {
    final StringBuilder builder = new StringBuilder(256);
    final StringBuilder builder2 = new StringBuilder(256);
    //TODO: these should be loadable from the web.xml
    builder.append("cah.DEBUG = false;\n");
    builder.append("cah.SILENT_DEBUG = true;\n");
    builder2.append(builder.toString());
    builder2.append("cah.AJAX_URI = 'AjaxServlet';\n");
    builder2.append("cah.LONGPOLL_URI = 'LongPollServlet';\n");

    String contextPath = config.getServletContext().getContextPath();
    if (!contextPath.endsWith("/")) {
      contextPath += "/";
    }
    builder.append(String.format("cah.AJAX_URI = '%sAjaxServlet';\n", contextPath));
    builder.append(String.format("cah.LONGPOLL_URI = '%sLongPollServlet';\n", contextPath));


    configString = builder.toString();
    configString2 = builder2.toString();

    super.init(config);
  }

  @Override
  protected void doGet(final HttpServletRequest req, final HttpServletResponse resp)
      throws ServletException, IOException {

    resp.setContentType("text/javascript");
    final PrintWriter out = resp.getWriter();
    if (req.getServerName().equals("pyz.ricin.us") || req.getServerName().equals("pyz.117.me")) 
    {
    	out.println(configString2);
    } else {
    	out.println(configString);
    }
    out.flush();
    out.close();
  }
}
