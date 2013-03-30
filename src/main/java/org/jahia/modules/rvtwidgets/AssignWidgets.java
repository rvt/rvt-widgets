package org.jahia.modules.rvtwidgets;

import org.jahia.ajax.gwt.client.service.GWTJahiaServiceException;
import org.jahia.ajax.gwt.helper.ContentManagerHelper;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionFactory;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.json.JSONObject;

import javax.jcr.NodeIterator;
import javax.jcr.RepositoryException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * Created with IntelliJ IDEA.
 * User: rvt
 * Date: 3/13/13
 * Time: 1:50 PM
 * To change this template use File | Settings | File Templates.
 */
public class AssignWidgets extends Action {
    private ContentManagerHelper contentManager;
    private static long NUMBER_COLUMNS=5;

    public void setContentManager(ContentManagerHelper contentManager) {
        this.contentManager = contentManager;
    }

    /**
     * Return a list of all widgets
     * @param jcrSessionWrapper
     * @param widgetsNode Root node of the widget's system
     * @param columns Number of columns in the widgets
     * @return
     */
    private Map<String, String> allCurrentWidgets(JCRSessionWrapper jcrSessionWrapper, JCRNodeWrapper widgetsNode,  int columns) {
        Map<String, String> allWidgets = new HashMap<String,String>();

        for (int i=1; i<=columns; i++) {
            try {
                NodeIterator nodes=widgetsNode.getNode("column" + i).getNodes();
                while (nodes.hasNext()) {
                    JCRNodeWrapper thisNode= (JCRNodeWrapper) nodes.next();
                    allWidgets.put(thisNode.getName(), thisNode.getPath());
                }
            } catch (RepositoryException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }
        }

        return allWidgets;
    }

    /**
     * Add a new widget to the user on a column with the least number of widgets
     *
     * @param jcrSessionWrapper
     * @param widgetsNode Base node of the widgets system
     * @param columns Number of columns visible to the user
     * @param widgetName Name of teh widget
     * @param widgetpath Path to copy the widget from
     * @throws GWTJahiaServiceException
     */
    private void addWidget(JCRSessionWrapper jcrSessionWrapper, JCRNodeWrapper widgetsNode, int columns, String widgetName, String widgetpath) throws GWTJahiaServiceException {
        JCRNodeWrapper selectedColumn=null;
        int numNodes=100;

        // FInd a column with the least amouth of subnodes so we can add them there
        for (int i=1; i<=columns; i++) {
            try {
                int numberofSubNodes=0;
                NodeIterator nodes=widgetsNode.getNode("column" + i).getNodes();
                while (nodes.hasNext()) {
                    JCRNodeWrapper thisNode= (JCRNodeWrapper) nodes.next();

                    // If we already have this node then return and don't add
                    if (thisNode.getName().equals(widgetName)) {
                        return;
                    }
                    numberofSubNodes++;
                }
                // If a column was found with less nodes, then use that
                if (numberofSubNodes<numNodes) {
                    numNodes=  numberofSubNodes;
                    selectedColumn=widgetsNode.getNode("column" + i);
                }
            } catch (RepositoryException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }
        }

        // Add the widget to the column
        if (selectedColumn!=null) {
            contentManager.copy(Arrays.asList(widgetpath), selectedColumn.getPath(), null, false, false, true, false, jcrSessionWrapper);
        }

    }


    public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource,
                                  JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver) throws Exception {

        String widgets = req.getParameter("widgets");
        String user = req.getParameter("user");
        String portalPath = req.getParameter("widgetPath");
        int columns = Integer.parseInt(req.getParameter("columns"));

        JCRSessionWrapper jcrSessionWrapper = JCRSessionFactory.getInstance().getCurrentUserSession(resource.getWorkspace(), resource.getLocale());
        JCRNodeWrapper userNode=jcrSessionWrapper.getNode(user);
        JCRNodeWrapper widgetsNode=null;

        // test if we have a widgets system in place, if not we return
        if (!userNode.hasNode(portalPath)) {
            return new ActionResult(HttpServletResponse.SC_OK, null, new JSONObject());
        } else {
            widgetsNode = userNode.getNode(portalPath);
        }

        JSONObject jsonWidgets = new JSONObject(widgets);

        // First delete all widfets that are not selected in  widgets list to make room for new widgets
        Map<String, String> allNodes = allCurrentWidgets(jcrSessionWrapper, widgetsNode, columns);
        for (Map.Entry<String, String> entry : allNodes.entrySet()) {
            if (!jsonWidgets.has(entry.getKey())) {
                jcrSessionWrapper.removeItem(entry.getValue());
            }
        }

        // Process all widgets and add them to available columns
        Iterator<?> keys = jsonWidgets.keys();
        while( keys.hasNext() ){
            String widgetName = (String) keys.next();
            String widgetPath = (String) jsonWidgets.get(widgetName);
            addWidget(jcrSessionWrapper, widgetsNode, columns, widgetName, widgetPath);
        }

        jcrSessionWrapper.save();
        return new ActionResult(HttpServletResponse.SC_OK, null, new JSONObject());
    }
}
