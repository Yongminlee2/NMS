package nms.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.LogOutputStream;
import org.apache.commons.exec.PumpStreamHandler;

public class Execute {
	protected final static boolean debug=true;
	public static class ExecResult extends LogOutputStream {
        private int exitCode;
        /**
         * @return the exitCode
         */
        public int getExitCode() {
            return exitCode;
        }

        /**
         * @param exitCode the exitCode to set
         */
        public void setExitCode(int exitCode) {
            this.exitCode = exitCode;
        }

        private final List<String> lines = new LinkedList<String>();

        @Override
        protected void processLine(String line, int level) {
            lines.add(line);
        }

        public List<String> getLines() {
            return lines;
        }
    }

    /**
     * execute the given command
     * @param cmd - the command 
     * @param exitValue - the expected exit Value
     * @return the output as lines and exit Code
     * @throws Exception
     */
    public static ExecResult execCmd(String cmd, int exitValue) throws Exception {
        
    	CommandLine commandLine = CommandLine.parse("su - sysop -c ");
    	commandLine.addArgument(cmd, false);
        DefaultExecutor executor = new DefaultExecutor();
        executor.setExitValue(exitValue);
        ExecResult result = new ExecResult();
        executor.setStreamHandler(new PumpStreamHandler(result));
        result.setExitCode(executor.execute(commandLine));
        return result;
    }
    
    public static String execCommand(String command,String arg2,String arg1) throws IOException {
        String line = null;
        ProcessBuilder builder = new ProcessBuilder(command, arg2,arg1);

//        Process child = Runtime.getRuntime().exec(command);
        Process child = builder.start();
        InputStream lsOut = child.getInputStream();
        InputStreamReader r = new InputStreamReader(lsOut);
        BufferedReader in = new BufferedReader(r);

        String readline = null;
        while ((readline = in.readLine()) != null) {
            line = line + readline;
        }

        return line;
    }
}
