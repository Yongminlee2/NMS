package nms.sec;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import nms.sec.vo.UserExt;
import nms.sec.vo.UserVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.jdbc.JdbcDaoImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;


public class JdbcDaoImplExt extends JdbcDaoImpl {
	
	@Autowired
	BCryptPasswordEncoder passwordEncode;
	
	@Override
	protected List<GrantedAuthority> loadUserAuthorities(String username)
	{
		return getJdbcTemplate().query(getAuthoritiesByUsernameQuery(), new String[] {username}, new RowMapper<GrantedAuthority>() {
			public GrantedAuthority mapRow(ResultSet rs, int rowNum) throws SQLException {

				String authority 	= rs.getString(2);
            	
		        GrantedAuthority grantedAtuthority = new SimpleGrantedAuthority(authority);

            	return grantedAtuthority;
            }
	   });
	}
	
	@Override
	protected List<UserDetails> loadUsersByUsername(String username)
	{
	    return getJdbcTemplate().query(getUsersByUsernameQuery(), new String[] {username}, new RowMapper<UserDetails>() {
			public UserExt mapRow(ResultSet rs, int rowNum) throws SQLException {
		
				String userId 		= rs.getString(1);
				String password 	= rs.getString(2);
				String userName 	= rs.getString(3);
				String company		= rs.getString(4);
				String authority 	= rs.getString(5);
				String accept		= rs.getString(6);
				
				UserVO userVO = new UserVO();
				userVO.setUserId(userId);
				userVO.setUserName(userName);
				userVO.setCompany(company);
				userVO.setAuthority(authority);
				userVO.setAccept(accept);
				
				Collection<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
				authorities.add(new SimpleGrantedAuthority(authority));

				return new UserExt(userId, password, true, true, true, true, authorities, userVO);
			}
		});
	}
	
	@Override
	protected UserDetails createUserDetails(final String username, final UserDetails userFromUserQuery, final List<GrantedAuthority> combinedAuthorities)
	{
		String returnUsername = userFromUserQuery.getUsername();

		  if (!isUsernameBasedPrimaryKey()) {
			  returnUsername = username;
		  }

		  final UserExt userToReturn = new UserExt(returnUsername,
		      userFromUserQuery.getPassword(), userFromUserQuery.isEnabled(), true,
		      true, true, combinedAuthorities, null);
		  userToReturn.setUserVO(((UserExt) userFromUserQuery).getUserVO());
		  return userToReturn;
	}
}
