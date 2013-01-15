<?xml version="1.0" encoding="UTF-8" ?>
<%--
Copyright (c) 2012, Andy Janata
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions
  and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of
  conditions and the following disclaimer in the documentation and/or other materials provided
  with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--%>
<%--
Administration tools.

@author Andy Janata (ajanata@socialgamer.net)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="net.socialgamer.cah.HibernateUtil" %>
<%@ page import="net.socialgamer.cah.db.BlackCard" %>
<%@ page import="net.socialgamer.cah.db.CardSet" %>
<%@ page import="net.socialgamer.cah.db.WhiteCard" %>
<%@ page import="net.socialgamer.cah.RequestWrapper" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%@ page import="org.hibernate.Session" %>
<%@ page import="org.hibernate.Transaction" %>
<%
RequestWrapper wrapper = new RequestWrapper(request);
String remoteAddr = wrapper.getRemoteAddr();
//TODO better access control than hard-coding IP addresses.
/*
if (!(remoteAddr.equals("0:0:0:0:0:0:0:1") || remoteAddr.equals("127.0.0.1") ||
    remoteAddr.startsWith("10.") || remoteAddr.equals("98.210.81.226"))) {
  response.sendError(403, "Access is restricted to known hosts");
  return;
}
*/
List<String> messages = new ArrayList<String>();

Session hibernateSession = HibernateUtil.instance.sessionFactory.openSession();
try {
// cheap way to make sure we can close the hibernate session at the end of the page
@SuppressWarnings("unchecked")
List<BlackCard> blackCards = hibernateSession.createQuery("from BlackCard order by id").setReadOnly(true).list();
  
@SuppressWarnings("unchecked")
List<WhiteCard> whiteCards = hibernateSession.createQuery("from WhiteCard order by id").setReadOnly(true).list();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>PYX - Edit Card Sets</title>
<script type="text/javascript" src="js/jquery-1.8.2.js"></script>
<script type="text/javascript">
  $(document).ready(function() {
  }
</script>
<style>
select {
  height: 300px;
}
</style>
</head>
<body>
<% for (String message : messages) { %>
  <h3><%= message %></h3>
<% } %>
  <h3>Available Black Cards:</h3>
  <br/>
  <ul>
    <% for (BlackCard blackCard : blackCards) { %>
      <li>[<%= blackCard.getId() %>] <%= blackCard.toString() %></li>
    <% } %>
    </ul>
  <h3>Available White Cards:</h3>
  <br/>
  <ul>
    <% for (WhiteCard whiteCard : whiteCards) { %>
      <li>[<%= whiteCard.getId() %>] <%= whiteCard.toString() %></li>
    <% } %>
  </ul>
</body>
</html>
<%
} finally {
  hibernateSession.close();
}
%>
