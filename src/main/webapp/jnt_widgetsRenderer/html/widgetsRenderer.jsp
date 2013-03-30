<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>

<%--@elvariable id="currentUser" type="org.jahia.services.usermanager.JahiaUser"--%>


<c:set var="writeable" value="${currentResource.workspace eq 'live'}"/>

<c:set target="${moduleMap}" property="subNodesView" value="${currentNode.properties['j:subNodesView'].string}"/>
<c:if test="${empty moduleMap.subNodesView}">
    <c:set target="${moduleMap}" property="subNodesView" value="widget"/>
</c:if>

<c:if test="${not writeable}">
    <fmt:message key="label.widget.only.live"/>
</c:if>


<template:addResources type="css" resources="jquery.colorbox.css,widgets.css"/>

    <template:addResources type="javascript"
                           resources="jquery.js,jquery-ui.min.js,inettuts.portal.js,ajaxreplace.js,jquery.colorbox.js,widgetSupport.js"/>

    <!--refresh needed on class="btn-slide active" window.location='<c:url value="${url.base}${currentNode.path}.html"/>';-->

    <div id="columns">
        <c:forEach var="column" begin="1" end="${currentNode.properties.columns.string}" varStatus="cStatus">
            <c:if test="${cStatus.last}">
                <c:set var="last" value=" last"/>
            </c:if>
            <ul id="column${column}" class="column${last}">
                <%-- Load up a contentList and read each column --%>
                <template:module path="column${column}" view="${moduleMap.subNodesView}"/>
            </ul>
        </c:forEach>
    </div>
    <div class="clear"></div>

<c:if test="${not writeable}">
    <template:module path="*" editable="false"/>
</c:if>