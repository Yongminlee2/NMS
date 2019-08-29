package nms.sec.vo;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

/**
 * User 클래스의 확장 클래스
 * 
 * @author 박용성
 * @since 2015.04.07
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일            수정자               수정내용
 *  -------      -------------    ----------------------
 *   2015.04.07      박용성               최초 생성
 *
 * </pre>
 */
public class UserExt extends User {

	private static final long serialVersionUID = 1L;
        
    /** 사용자 VO객체 */
    private Object userVO; 
    
    /**
     * User 클래스의 생성자 Override
     * @param username 사용자계정
     * @param password 사용자 패스워드
     * @param enabled 사용자계정 사용여부
     * @param accountNonExpired boolean
     * @param credentialsNonExpired boolean
     * @param accountNonLocked boolean
     * @param authorities GrantedAuthority[]
     * @param userVO 사용자 VO객체
     * @throws IllegalArgumentException 
     */
    public UserExt(String username, String password, boolean enabled,
                    boolean accountNonExpired, boolean credentialsNonExpired,
                    boolean accountNonLocked, Collection<GrantedAuthority> authorities, Object userVO)
                    throws IllegalArgumentException {
        
    	super(username, password, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked, authorities);

    	this.userVO = userVO;
    }

    /**
     * getUserVO
     * @return 사용자VO 객체
     */
    public Object getUserVO() {
    	return userVO;
    }

    /**
     * setUserVO
     * @param userVO 사용자VO객체
     */
    public void setUserVO(Object userVO) {
    	this.userVO = userVO;
    }
}