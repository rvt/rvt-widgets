<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>

<%--@elvariable id="currentUser" type="org.jahia.services.usermanager.JahiaUser"--%>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="node" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>


<template:include view="hidden.widgetMap"/>


<template:addCacheDependency flushOnPathMatchingRegexp="\Q${widgets.path}\E/.*"/>

<c:set var="widgetsAdded" value="${moduleMap.widgetsAdded}"/>
<c:set var="widgetsPath" value="${moduleMap.widgetsPath}"/>

<div class="allWidgets">

    <c:if test="${moduleMap.emptyWidgetList == true}">
        ${currentNode.properties.customizeEmtyList.string}
    </c:if>

    <c:if test="${not moduleMap.emptyWidgetList}">
        <c:if test="${not empty currentNode.properties.customizePopupText}">
            ${currentNode.properties.customizePopupText.string}
        </c:if>
        <c:if test="${empty currentNode.properties.customizePopupText}">
            <h3><fmt:message key="label.widget.addComponents"/></h3>
        </c:if>
        <c:forEach items="${widgetsPath}" var="entry" varStatus="status">
            <c:if test="${not widgetsAdded[entry.key]}">
                <jcr:node path="${widgetsPath[entry.key]}" var="node"/>
                <c:set var="widgetTitle" value="${functions:removeHtmlTags(node.displayableName)}"/>
                <a href="#"
                   onclick="addWidget('${node.path}','${node.name}')">${fn:substring(widgetTitle, 0,40)} ${fn:length(widgetTitle) > 40?" ...":""}</a><br/>
            </c:if>
        </c:forEach>
    </c:if>

</div>
