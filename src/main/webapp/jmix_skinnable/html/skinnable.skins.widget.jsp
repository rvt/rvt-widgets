<%@ taglib uri="http://www.jahia.org/tags/jcr" prefix="jcr" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<template:addResources type="css" resources="box.css"/>

<div class="widget">
    <h2 class="widget-head"><jcr:nodeProperty node="${currentNode}" name="jcr:title"/></h2>
    <div class="widgetBody">
        ${wrappedContent}
    </div>
</div>

