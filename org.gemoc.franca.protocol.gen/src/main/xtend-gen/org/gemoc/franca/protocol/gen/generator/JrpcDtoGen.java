package org.gemoc.franca.protocol.gen.generator;

import com.google.common.base.Objects;
import java.util.Arrays;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.franca.core.franca.FBasicTypeId;
import org.franca.core.franca.FField;
import org.franca.core.franca.FStructType;
import org.franca.core.franca.FType;
import org.franca.core.franca.FTypeCollection;
import org.franca.core.franca.FTypeRef;

@SuppressWarnings("all")
public class JrpcDtoGen {
  public CharSequence generateDtoClass(final List<FTypeCollection> typeCollections, final String basePackageName) {
    return this.generateData(typeCollections, basePackageName);
  }

  private CharSequence generateData(final List<FTypeCollection> typeCollections, final String basePackageName) {
    StringConcatenation _builder = new StringConcatenation();
    CharSequence _generateHeader = this.generateHeader(basePackageName);
    _builder.append(_generateHeader);
    _builder.newLineIfNotEmpty();
    {
      for(final FTypeCollection typeCollection : typeCollections) {
        _builder.append("\t");
        CharSequence _generate = this.generate(typeCollection);
        _builder.append(_generate, "\t");
        _builder.append("\t\t ");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("\t");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generate(final FTypeCollection collection) {
    StringConcatenation _builder = new StringConcatenation();
    {
      EList<FType> _types = collection.getTypes();
      for(final FType type : _types) {
        CharSequence _generate = this.generate(type);
        _builder.append(_generate);
        _builder.newLineIfNotEmpty();
        _builder.newLine();
      }
    }
    _builder.newLine();
    return _builder;
  }

  private CharSequence _generate(final FType type) {
    try {
      throw new Exception("You should not pass there ! You need to handle the missing concrete type");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }

  private CharSequence _generate(final FStructType type) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("class ");
    String _name = type.getName();
    _builder.append(_name);
    _builder.append(" {");
    _builder.newLineIfNotEmpty();
    {
      EList<FField> _elements = type.getElements();
      for(final FField element : _elements) {
        _builder.append("\t");
        String _generate = this.generate(element.getType());
        _builder.append(_generate, "\t");
        _builder.append(" ");
        String _name_1 = element.getName();
        _builder.append(_name_1, "\t");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private String generate(final FTypeRef it) {
    String _xifexpression = null;
    FType _derived = it.getDerived();
    boolean _notEquals = (!Objects.equal(_derived, null));
    if (_notEquals) {
      _xifexpression = it.getDerived().getName();
    } else {
      String _switchResult = null;
      FBasicTypeId _predefined = it.getPredefined();
      if (_predefined != null) {
        switch (_predefined) {
          case STRING:
            _switchResult = "String";
            break;
          case BOOLEAN:
            _switchResult = "Boolean";
            break;
          default:
            String _string = it.getPredefined().toString();
            String _plus = ("/*" + _string);
            _switchResult = (_plus + "*/");
            break;
        }
      } else {
        String _string = it.getPredefined().toString();
        String _plus = ("/*" + _string);
        _switchResult = (_plus + "*/");
      }
      _xifexpression = _switchResult;
    }
    return _xifexpression;
  }

  private CharSequence generateHeader(final String basePackageName) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("/*---------------------------------------------------------------------------------------------");
    _builder.newLine();
    _builder.append(" ");
    _builder.append("* Copyright (c) 2020 Inria and others.");
    _builder.newLine();
    _builder.append(" ");
    _builder.append("* All rights reserved. This program and the accompanying materials");
    _builder.newLine();
    _builder.append(" ");
    _builder.append("* are made available under the terms of the Eclipse Public License v1.0");
    _builder.newLine();
    _builder.append(" ");
    _builder.append("* which accompanies this distribution, and is available at");
    _builder.newLine();
    _builder.append(" ");
    _builder.append("* http://www.eclipse.org/legal/epl-v10.html");
    _builder.newLine();
    _builder.append(" ");
    _builder.append("*--------------------------------------------------------------------------------------------*/");
    _builder.newLine();
    _builder.append("/* GENERATED FILE, DO NOT MODIFY MANUALLY */");
    _builder.newLine();
    _builder.newLine();
    _builder.append("package ");
    _builder.append(basePackageName);
    _builder.append(".data;");
    _builder.newLineIfNotEmpty();
    _builder.newLine();
    _builder.append("import java.util.Map");
    _builder.newLine();
    _builder.append("import org.eclipse.lsp4j.generator.JsonRpcData");
    _builder.newLine();
    _builder.append("import org.eclipse.lsp4j.jsonrpc.messages.Either");
    _builder.newLine();
    _builder.append("import org.eclipse.lsp4j.jsonrpc.validation.NonNull");
    _builder.newLine();
    _builder.append("/** Declaration of data classes and enum for the EngineAddonProtocolData.");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("Auto-generated from json schema. Do not edit manually.");
    _builder.newLine();
    _builder.append("*/");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generate(final FType type) {
    if (type instanceof FStructType) {
      return _generate((FStructType)type);
    } else if (type != null) {
      return _generate(type);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(type).toString());
    }
  }
}
