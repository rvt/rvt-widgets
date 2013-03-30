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

<c:set var="minNumWidgets" value="${currentNode.properties.componentsFolder.node.path}"/>

<script type="text/javascript">
    minimumNumberOfWidgets = ${currentNode.properties.minimumNumberOfWidgets.string};
    maximumNumberOfWidgets = ${currentNode.properties.maximumNumberOfWidgets.string};
    userWidgets = {}
</script>




<div class="allWidgets">
    <c:if test="${not empty currentNode.properties.customizePopupText}">
        ${currentNode.properties.customizePopupText.string}
    </c:if>
    <c:if test="${empty currentNode.properties.customizePopupText}">
        <h3><fmt:message key="label.widget.addComponents"/></h3>
    </c:if>
    <c:forEach items="${widgetsPath}" var="entry" varStatus="status">

        <jcr:node path="${widgetsPath[entry.key]}" var="node"/>

        <c:set var="checked" value=""/>
        <c:if test="${widgetsAdded[entry.key]}">
            <c:set var="checked" value='checked="checked"'/>
            <script>
                userWidgets['${node.name}'] = '${node.path}'
            </script>
        </c:if>

        <c:set var="widgetTitle" value="${functions:removeHtmlTags(node.displayableName)}"/>
        <div class="checkRow">
            <input type="checkbox" ${checked}
                   onclick="userWidgets=addRemoveWidget(event,userWidgets, $(this), '${node.name}', '${node.path}');updateSelectDisplay(userWidgets, ${currentNode.properties.displayWarningMessages.string});"/><span>${fn:substring(widgetTitle, 0,40)} ${fn:length(widgetTitle) > 40?" ...":""}</span>
        </div>
        <br/>

    </c:forEach>
</div>

<fmt:message var="minimumReachedMsg" key="jnt_widgetsCustomizerChecked.minimumNumberWidgetsReached"><fmt:param value="${currentNode.properties.minimumNumberOfWidgets.string}"/></fmt:message>
<fmt:message var="maximumReachedMsg" key="jnt_widgetsCustomizerChecked.maximumNumberWidgetsReached"><fmt:param value="${currentNode.properties.maximumNumberOfWidgets.string}"/></fmt:message>
<p class="widgetReachedMsg" id="minimumReached" style="display: none;position: absolute">${minimumReachedMsg}</p>
<p class="widgetReachedMsg" id="maximumReached" style="display: none;position: absolute">${maximumReachedMsg}</p>

<br />
<br />
<div class="row">
    <input type="button" id="submitWidgets"  class="btnSubmit" value="submit" onclick="submitAddWidgets(userWidgets)" />
    <input type="submit" class="btnReset" value="reset" onclick="submitResetWidgets(userWidgets)">
</div>
<div class="clear"></div>
<br />
