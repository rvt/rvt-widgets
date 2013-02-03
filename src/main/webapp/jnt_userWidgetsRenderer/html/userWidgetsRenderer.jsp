<%@ page import="org.jahia.services.content.JCRNodeWrapper" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>

<%--@elvariable id="currentUser" type="org.jahia.services.usermanager.JahiaUser"--%>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<c:set var="portalPath" value="rvtwidgets${fn:replace(renderContext.mainResource.node.path,'/','_')}"/>
<jcr:node var="user" path="${renderContext.user.localPath}"/>
<jcr:node var="portal" path="${user.path}/${portalPath}"/>

<template:addCacheDependency flushOnPathMatchingRegexp="\Q${portal.path}\E/.*" />


<template:addResources type="javascript" resources="jquery.js"/>


<c:set var="writeable" value="${currentResource.workspace eq 'live'}"/>

<c:if test="${writeable}">
    <c:if test="${empty portal}">
        <form action="<c:url value='${url.base}${user.path}.cloneWidgets.do'/>" id="form${currentNode.identifier}"
              method="post">
            <input type="hidden" name="widgetPath" value="${portalPath}"/>
            <input type="hidden" name="jcrRedirectTo" value="<c:url value='${url.base}${renderContext.mainResource.node.path}'/>"/>
            <input type="hidden" name="defaultWidget" value="${currentNode.properties['defaultWidget'].string}"/>
            <c:set var="ps" value=""/>
            <c:forEach items="${param}" var="p">
                <c:if test="${not empty ps}">
                    <c:set var="ps" value="${ps}&${p.key}=${p.value}" />
                </c:if>
                <c:if test="${empty ps}">
                    <c:set var="ps" value="?${p.key}=${p.value}" />
                </c:if>
            </c:forEach>
            <!--input type="hidden" name="jcrNewNodeOutputFormat" value="user-portal.html${ps}"/-->
            <h4><fmt:message key="label.portal.create"/>:</h4>
            <input class="button" type="submit" name="jcrSubmit" value="<fmt:message key='label.submit'/>"/>
        </form>
        <script>
            $(document).ready(function () {
               $("#form${currentNode.identifier}").submit();
            });

        </script>
    </c:if>
    <c:if test="${not empty portal}">
        <template:module path="${user.path}/rvtwidgets${fn:replace(renderContext.mainResource.node.path,'/','_')}" editable="false"/>
    </c:if>
</c:if>

<c:if test="${not writeable}">
    <fmt:message key="label.widget.only.live"/>
</c:if>
