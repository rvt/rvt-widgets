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

<jcr:node path="${param['path']}" var="widgets"/>
<jcr:node path="${param['portal']}" var="portal"/>
<template:addCacheDependency flushOnPathMatchingRegexp="\Q${widgets.path}\E/.*"/>


<jsp:useBean id="widgetsPath" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="widgetsAdded" class="java.util.HashMap" scope="request"/>

<c:set var="emptyWidgetList" value="true"/>

<c:forEach items="${widgets.nodes}" var="node" varStatus="status">
    <c:if test="${!jcr:isNodeType(node, 'jnt:acl' )}">
        <c:if test="${jcr:isNodeType(node, 'jmix:nodeReference')}">
            <%-- Add dependency to references --%>
            <template:addCacheDependency uuid="${node.properties['j:node'].string}"/>
        </c:if>

        <%-- test if the user already has teh widget added --%>
        <c:set var="hasAdded" value="false"/>
        <c:forEach begin="1" end="5" var="colNo">
            <c:set var="testpath" value="${portal.path}/column${colNo}/${node.name}"/>
            <c:set var="columnNode" value="${null}"/>
            <c:catch>
                <jcr:node path="${testpath}" var="columnNode"/>
            </c:catch>
            <c:if test="${columnNode!=null}">
                <c:set var="hasAdded" value="true"/>
            </c:if>
        </c:forEach>


        <c:set target="${widgetsPath}" property="${node.name}" value="${node.path}"/>
        <c:set target="${widgetsAdded}" property="${node.name}" value="${hasAdded}"/>

        <c:if test="${not hasAdded}">
            <c:set var="emptyWidgetList" value="false"/>
        </c:if>
    </c:if>
</c:forEach>

<c:set target="${moduleMap}" property="emptyWidgetList" value="${emptyWidgetList}" />
<c:set target="${moduleMap}" property="widgetsPath" value="${widgetsPath}" />
<c:set target="${moduleMap}" property="widgetsAdded" value="${widgetsAdded}" />
