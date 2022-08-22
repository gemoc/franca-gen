package org.gemoc.franca.protocol.gen.cli;

import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.gemoc.franca.protocol.gen.generator.AbstractProtocolGenerator;
import org.gemoc.franca.protocol.gen.generator.GeneratorKind;
import org.gemoc.franca.protocol.gen.generator.java.ProtocolGenerator4Java;

public class GeneratorCLI {

	public static void main(String[] args) {
		Options options = new Options();
		options .addOption("h", "help", false, "print this help")
				.addRequiredOption("f", "fdepl", true,
						"fdepl file  representing the deployment directives of the protocol to generate")
				.addRequiredOption("g", "generator", true,
						"name of the generator, possible values: "
								+ Stream.of(GeneratorKind.values()).map(n -> n.name()).collect(Collectors.joining(",")))
				.addRequiredOption("o", "outfolder", true, "path to folder where to generate");

		CommandLineParser parser = new DefaultParser();

		// parse the options passed as command line arguments
		try {
			CommandLine cmd = parser.parse(options, args);

			String fdeplFile = cmd.hasOption("f") ? cmd.getOptionValue("f") : "";
			String generatorName = cmd.hasOption("g") ? cmd.getOptionValue("g") : "";
			String outFolder = cmd.hasOption("o") ? cmd.getOptionValue("o") : "";
			
			if(cmd.hasOption("h")) {
				printHelp(options);
			}
			
			try {
				GeneratorKind generatorKind  = GeneratorKind.valueOf(generatorName);
				AbstractProtocolGenerator generator = null;
				switch (generatorKind) {
				case java:
					generator =  new ProtocolGenerator4Java(fdeplFile, outFolder);
					break;
				default:
					System.err.println("generator "+generatorName + " not implemented");
					printHelp(options);
					System.exit(-1);
				}
				generator.generate();
			} catch (java.lang.IllegalArgumentException e) {
				System.err.println("Unknown generator "+generatorName);
				printHelp(options);
				System.exit(-1);
			}

		} catch (ParseException e) {

			printHelp(options);
			System.exit(0);
		}

	}

	public static void printHelp(Options options) {
		HelpFormatter formatter = new HelpFormatter();
		formatter.printHelp("java -jar org.gemoc.franca.protocol.gen-0.0.1-SNAPSHOT.jar", "== GEMOC FrancaProtocolGenerator command line ==", options, "");
	}
}
