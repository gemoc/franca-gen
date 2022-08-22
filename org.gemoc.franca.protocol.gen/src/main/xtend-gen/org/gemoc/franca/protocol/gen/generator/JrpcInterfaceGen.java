package org.gemoc.franca.protocol.gen.generator;

import com.google.common.base.Objects;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.franca.core.franca.FArgument;
import org.franca.core.franca.FBasicTypeId;
import org.franca.core.franca.FInterface;
import org.franca.core.franca.FMethod;
import org.franca.core.franca.FType;
import org.franca.core.franca.FTypeRef;
import org.franca.deploymodel.core.FDeployedInterface;
import org.gemoc.franca.protocol.lib.spec.RPCSpec;

@SuppressWarnings("all")
public class JrpcInterfaceGen {
  private RPCSpec.InterfacePropertyAccessor deploy;

  public CharSequence generateInterface(final FDeployedInterface deployed, final String basePackageName) {
    CharSequence _xblockexpression = null;
    {
      RPCSpec.InterfacePropertyAccessor _interfacePropertyAccessor = new RPCSpec.InterfacePropertyAccessor(deployed);
      this.deploy = _interfacePropertyAccessor;
      _xblockexpression = this.generateInterface(deployed.getFInterface(), basePackageName);
    }
    return _xblockexpression;
  }

  private CharSequence generateInterface(final FInterface api, final String basePackageName) {
    StringConcatenation _builder = new StringConcatenation();
    CharSequence _generateHeader = this.generateHeader(api, basePackageName);
    _builder.append(_generateHeader);
    _builder.newLineIfNotEmpty();
    _builder.append("public interface ");
    String _name = api.getName();
    _builder.append(_name);
    _builder.append(" {");
    _builder.newLineIfNotEmpty();
    {
      EList<FMethod> _methods = api.getMethods();
      for(final FMethod m : _methods) {
        _builder.append("\t");
        CharSequence _generateMethodDeclaration = this.generateMethodDeclaration(m);
        _builder.append(_generateMethodDeclaration, "\t");
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

  private CharSequence generateHeader(final FInterface api, final String basePackageName) {
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
    _builder.append(".services;");
    _builder.newLineIfNotEmpty();
    _builder.newLine();
    _builder.append("import com.google.gson.annotations.SerializedName;");
    _builder.newLine();
    _builder.append("import java.util.concurrent.CompletableFuture;");
    _builder.newLine();
    _builder.append("import org.eclipse.lsp4j.jsonrpc.services.JsonRequest;");
    _builder.newLine();
    _builder.append("import ");
    _builder.append(basePackageName);
    _builder.append(".data.*;");
    _builder.newLineIfNotEmpty();
    _builder.append("/** Server interface for the model execution trace protocol.");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("Auto-generated from Franca declaration. Do not edit manually.");
    _builder.newLine();
    _builder.append("*/");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generateMethodDeclaration(final FMethod method) {
    StringConcatenation _builder = new StringConcatenation();
    String _xifexpression = null;
    Boolean _isNotification = this.deploy.getIsNotification(method);
    if ((_isNotification).booleanValue()) {
      _xifexpression = "@JsonNotification";
    } else {
      _xifexpression = "@JsonRequest";
    }
    _builder.append(_xifexpression);
    _builder.newLineIfNotEmpty();
    _builder.append("default ");
    String _xifexpression_1 = null;
    boolean _isNullOrEmpty = IterableExtensions.isNullOrEmpty(method.getOutArgs());
    if (_isNullOrEmpty) {
      _xifexpression_1 = "void";
    } else {
      FArgument _get = method.getOutArgs().get(0);
      FTypeRef _type = null;
      if (_get!=null) {
        _type=_get.getType();
      }
      _xifexpression_1 = this.generate(_type);
    }
    _builder.append(_xifexpression_1);
    _builder.append(" CompletableFuture<");
    {
      EList<FArgument> _inArgs = method.getInArgs();
      for(final FArgument attr : _inArgs) {
        String _generate = this.generate(attr.getType());
        _builder.append(_generate);
        _builder.append(" ");
        String _name = attr.getName();
        _builder.append(_name);
      }
    }
    _builder.append(">");
    _builder.newLineIfNotEmpty();
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
}
