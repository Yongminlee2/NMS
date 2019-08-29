package nms.sec;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Ajax 세션관리 클래스
 * 
 * @author 박용성
 * @since 2014.05.27
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일            수정자               수정내용
 *  -------      -------------    ----------------------
 *   2014.05.27      박용성               최초 생성
 *
 * </pre>
 */
public class AjaxSessionTimeoutFilter implements Filter {

    private String ajaxHeader;
    
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        if (isAjaxRequest(req)) {
            try {
                chain.doFilter(req, res);
            } catch (AccessDeniedException e) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
            } catch (AuthenticationException e) {
                res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            }
        } else {
            chain.doFilter(req, res);
        }
    }

    private boolean isAjaxRequest(HttpServletRequest req) {
        return req.getHeader(ajaxHeader) != null    && req.getHeader(ajaxHeader).equals(Boolean.TRUE.toString());
    }
    
    public void setAjaxHeader(String ajaxHeader)
    {
    	this.ajaxHeader = ajaxHeader;
    }

    public void init(FilterConfig filterConfig) {}
    public void destroy() {}
}