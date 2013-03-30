<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>

<%--@elvariable id="currentUser" type="org.jahia.services.usermanager.JahiaUser"--%>

<c:set var="portalPath" value="rvtwidgets${fn:replace(renderContext.mainResource.node.path,'/','_')}"/>
<jcr:node var="user" path="${renderContext.user.localPath}"/>
<jcr:node var="portal" path="${user.path}/${portalPath}"/>
<template:addCacheDependency flushOnPathMatchingRegexp="\Q${portal.path}\E/.*" />

<c:set var="writeable" value="${currentResource.workspace eq 'live'}"/>
<template:addResources type="css" resources="jquery.colorbox.css,widgets.css"/>


<c:if test="${writeable && not empty portal}">
    <template:addResources type="javascript"
                           resources="jquery.js,jquery-ui.min.js,inettuts.portal.js,ajaxreplace.js,jquery.colorbox.js"/>
</c:if>

<fmt:message var="jnt_widgets_delete_minimumWidgetsReached" key="jnt_widgets.delete.minimumWidgetsReached"><fmt:param value="${currentNode.properties.minimumNumberOfWidgets.string}"/></fmt:message>

<c:if test="${not renderContext.editMode}">
<script>
    var jnt_widgets_delete_minimumWidgetsReached = "${jnt_widgets_delete_minimumWidgetsReached}"
    $(document).ready(function () {
        $(".customizeWidget").colorbox();
        iNettuts.settings.widgetDefault.movable=${currentNode.properties.allowMovable.boolean?'true':'false'};
        iNettuts.settings.widgetDefault.removable=${currentNode.properties.allowRemovable.boolean?'true':'false'};
        iNettuts.addWidgetControls( );
        iNettuts.makeSortable();
    });

</script>
</c:if>

<c:if test="${writeable}">
    <c:url var="myUrl" value="${url.base}${currentNode.path}.select.html.ajax">
        <c:param name="path" value="${currentNode.properties.componentsFolder.node.path}"/>
        <c:param name="portal" value="${portal.path}"/>
    </c:url>
</c:if>

<c:if test="${not empty portal || currentResource.workspace eq 'default'}">
    <a class='customizeWidget' href="${myUrl}">${currentNode.properties.customizeLabel.string}</a>
</c:if>


