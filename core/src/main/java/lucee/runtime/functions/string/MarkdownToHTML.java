package lucee.runtime.functions.string;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.Charset;

import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;

import lucee.commons.io.CharsetUtil;
import lucee.commons.io.IOUtil;
import lucee.commons.io.res.Resource;
import lucee.commons.io.res.util.ResourceUtil;
import lucee.commons.lang.StringUtil;
import lucee.runtime.PageContext;
import lucee.runtime.engine.ThreadLocalPageContext;
import lucee.runtime.exp.FunctionException;
import lucee.runtime.exp.PageException;
import lucee.runtime.ext.function.BIF;
import lucee.runtime.ext.function.Function;
import lucee.runtime.op.Caster;

public class MarkdownToHTML extends BIF implements Function {

	private static final long serialVersionUID = 3775127934350736736L;

	@Override
	public Object invoke(PageContext pc, Object[] args) throws PageException {
		if (args.length < 1 || args.length > 2) {
			throw new FunctionException(pc, "MarkdownToHTML", 1, 2, args.length);
		}
		return call(pc, Caster.toString(args[0]));
	}

	public static String call(PageContext pc, String markdown) throws PageException {
		return call(pc, markdown, false, null);
	}

	public static String call(PageContext pc, String markdown, boolean safeMode) throws PageException {
		return call(pc, markdown, safeMode, null);
	}

	public static String call(PageContext pc, String markdown, boolean safeMode, String encoding) throws PageException {
		if (markdown.length() < 2000 && !StringUtil.isEmpty(markdown, true)) {
			Resource res = ResourceUtil.toResourceExisting(pc, markdown.trim(), false, null);
			if (res != null) {
				Charset cs;
				if (StringUtil.isEmpty(encoding, true)) cs = ThreadLocalPageContext.getConfig(pc).getWebCharset();
				else cs = CharsetUtil.toCharset(encoding.trim());

				BufferedReader br = null;
				try {
					// TODO add safemode
					br = new BufferedReader(new InputStreamReader(res.getInputStream(), cs));

					Parser parser = Parser.builder().build();
					// Parse the markdown to a Node
					Node document = parser.parseReader(br);
					// Create a HTML renderer
					HtmlRenderer renderer = HtmlRenderer.builder().build();
					// Render the Node to HTML
					return renderer.render(document);
				}
				catch (IOException e) {
					throw Caster.toPageException(e);
				}
				finally {
					IOUtil.closeEL(br);
				}

			}
		}

		Parser parser = Parser.builder().build();
		// Parse the markdown to a Node
		Node document = parser.parse(markdown);
		// Create a HTML renderer
		HtmlRenderer renderer = HtmlRenderer.builder().build();
		// Render the Node to HTML
		return renderer.render(document);
	}

	/*
	 * public static void main(String[] args) { print.e(Processor.process("This is ***TXTMARK***",
	 * false)); }
	 */
}