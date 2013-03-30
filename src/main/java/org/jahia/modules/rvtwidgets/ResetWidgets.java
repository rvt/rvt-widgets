package org.jahia.modules.rvtwidgets;

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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * Reset the widgets to a default state
 *
 * Created with IntelliJ IDEA.
 * User: rvt
 * Date: 3/13/13
 * Time: 4:13 PM
 * To change this template use File | Settings | File Templates.
 */
public class ResetWidgets extends Action {

    private ContentManagerHelper contentManager;

    public void setContentManager(ContentManagerHelper contentManager) {
        this.contentManager = contentManager;
    }

    public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource,
                                  JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver) throws Exception {
        String user = req.getParameter("user");
        String portalPath = req.getParameter("widgetPath");
        String source = req.getParameter("source");

        JCRSessionWrapper jcrSessionWrapper = JCRSessionFactory.getInstance().getCurrentUserSession(resource.getWorkspace(), resource.getLocale());
        JCRNodeWrapper userNode=jcrSessionWrapper.getNode(user);

        // test if we have a widgets system in place, if so remove it so we can make a fresh copy
        if (userNode.hasNode(portalPath)) {
            jcrSessionWrapper.removeItem(user+"/"+portalPath);
            jcrSessionWrapper.save();
        }

        // Copy default back in place
        contentManager.copy(Arrays.asList(source),user,null,false,false,true, false, jcrSessionWrapper);

        return new ActionResult(HttpServletResponse.SC_OK, null, new JSONObject());
    }
}
