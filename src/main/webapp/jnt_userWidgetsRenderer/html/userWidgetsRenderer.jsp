<%@ page import="org.jahia.services.content.JCRNodeWrapper" %>
<%@ page import="org.jahia.services.render.RenderContext" %>
<%@ page import="org.jahia.services.usermanager.JahiaUser" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>

<%--@elvariable id="currentUser" type="org.jahia.services.usermanager.JahiaUser"--%>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>

<c:set var="portalPath" value="rvtwidgets${fn:replace(renderContext.mainResource.node.path,'/','_')}"/>
<jcr:node var="user" path="${renderContext.user.localPath}"/>
<jcr:node var="portal" path="${user.path}/${portalPath}"/>
<c:set var="isLive" value="${currentResource.workspace eq 'live'}"/>

<%

    RenderContext renderContext = (RenderContext) request.getAttribute("renderContext");
    JCRNodeWrapper currentNode=(JCRNodeWrapper)request.getAttribute("currentNode");

    Boolean isLive = (Boolean) pageContext.getAttribute("isLive");
    if (isLive) { // only create portals in live mode
        JCRNodeWrapper portal = (JCRNodeWrapper) pageContext.getAttribute("portal");
        if (portal == null) { // Only create a portal if there was no portal
            String user = (String) renderContext.getUser().getLocalPath();
            String portalPath = (String) pageContext.getAttribute("portalPath");
            JCRNodeWrapper defaultWidget=(JCRNodeWrapper) currentNode.getProperty("defaultWidget").getNode();
            JCRNodeWrapper userNode=currentNode.getSession().getNode(user);

            if (defaultWidget!=null && StringUtils.isNotEmpty(defaultWidget.getPath())) {
                defaultWidget.copy(userNode, portalPath, false);
                defaultWidget.getSession().save();
            } else {
                userNode.addNode("portalPath", "jnt:widgetsRenderer");
                userNode.getSession().save();
            }
        }
    }

%>

<jcr:node var="portal" path="${user.path}/${portalPath}"/>
<template:addCacheDependency flushOnPathMatchingRegexp="\Q${portal.path}\E/.*" />
<template:addResources type="javascript" resources="jquery.js"/>

<c:if test="${isLive}">
    <c:if test="${not empty portal}">
        <template:module path="${user.path}/rvtwidgets${fn:replace(renderContext.mainResource.node.path,'/','_')}" editable="false"/>
    </c:if>
</c:if>

<c:if test="${not isLive}">
    <div><fmt:message key="label.widget.only.live"/></div>
</c:if>

