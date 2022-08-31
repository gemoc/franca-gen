/*******************************************************************************
* This file has been generated by Franca's FDeployGenerator.
* Source: deployment specification 'RPCSpec'
*******************************************************************************/
package org.gemoc.franca.protocol.lib.spec;

import java.util.Map;

import org.franca.core.franca.FArgument;
import org.franca.core.franca.FArrayType;
import org.franca.core.franca.FAttribute;
import org.franca.core.franca.FEnumerator;
import org.franca.core.franca.FField;
import org.franca.core.franca.FInterface;
import org.franca.core.franca.FMethod;
import org.franca.core.franca.FModelElement;
import org.franca.deploymodel.core.FDeployedInterface;
import org.franca.deploymodel.core.FDeployedRootElement;
import org.franca.deploymodel.core.FDeployedTypeCollection;
import org.franca.deploymodel.core.MappingGenericPropertyAccessor;
import org.franca.deploymodel.dsl.fDeploy.FDCompoundOverwrites;
import org.franca.deploymodel.dsl.fDeploy.FDEnumValue;
import org.franca.deploymodel.dsl.fDeploy.FDEnumerationOverwrites;
import org.franca.deploymodel.dsl.fDeploy.FDExtensionRoot;
import org.franca.deploymodel.dsl.fDeploy.FDField;
import org.franca.deploymodel.dsl.fDeploy.FDOverwriteElement;
import org.franca.deploymodel.dsl.fDeploy.FDTypeOverwrites;

import com.google.common.collect.Maps;

/**
 * This is a collection of all interfaces and classes needed for
 * accessing deployment properties according to deployment specification
 * 'RPCSpec'.
 */
public class RPCSpec {

	/**
	 * Enumerations for deployment specification RPCSpec.
	 */
	public interface Enums
	{
		public enum ArgsType {
			dedicatedClass, optimized
		}
		 
	}

	/**
	 * Interface for data deployment properties for 'RPCSpec' specification
	 * 
	 * This is the data types related part only.
	 */
	public interface IDataPropertyAccessor
		extends Enums
	{
		
		/**
		 * Get an overwrite-aware accessor for deployment properties.</p>
		 *
		 * This accessor will return overwritten property values in the context 
		 * of a Franca FField object. I.e., the FField obj has a datatype
		 * which can be overwritten in the deployment definition (e.g., Franca array,
		 * struct, union or enumeration). The accessor will return the overwritten values.
		 * If the deployment definition didn't overwrite the value, this accessor will
		 * delegate to its parent accessor.</p>
		 *
		 * @param obj a Franca FField which is the context for the accessor
		 * @return the overwrite-aware accessor
		 */
		public IDataPropertyAccessor getOverwriteAccessor(FField obj);
	
		/**
		 * Get an overwrite-aware accessor for deployment properties.</p>
		 *
		 * This accessor will return overwritten property values in the context 
		 * of a Franca FArrayType object. I.e., the FArrayType obj has a datatype
		 * which can be overwritten in the deployment definition (e.g., Franca array,
		 * struct, union or enumeration). The accessor will return the overwritten values.
		 * If the deployment definition didn't overwrite the value, this accessor will
		 * delegate to its parent accessor.</p>
		 *
		 * @param obj a Franca FArrayType which is the context for the accessor
		 * @return the overwrite-aware accessor
		 */
		public IDataPropertyAccessor getOverwriteAccessor(FArrayType obj);
	}

	/**
	 * Helper class for data-related property accessors.
	 */		
	public static class DataPropertyAccessorHelper implements Enums
	{
		final private MappingGenericPropertyAccessor target;
		final private IDataPropertyAccessor owner;
		
		public DataPropertyAccessorHelper(
			MappingGenericPropertyAccessor target,
			IDataPropertyAccessor owner
		) {
			this.target = target;
			this.owner = owner;
		}
	
		public static ArgsType convertArgsType(String val) {
			if (val.equals("dedicatedClass"))
				return ArgsType.dedicatedClass; else 
			if (val.equals("optimized"))
				return ArgsType.optimized;
			return null;
		}
		
		
		protected IDataPropertyAccessor getOverwriteAccessorAux(FModelElement obj) {
			FDOverwriteElement fd = (FDOverwriteElement)target.getFDElement(obj);
			FDTypeOverwrites overwrites = fd.getOverwrites();
			if (overwrites==null)
				return owner;
			else
				return new OverwriteAccessor(overwrites, owner, target);
		}
	}

	/**
	 * Accessor for deployment properties for Franca type collections according
	 * to deployment specification 'RPCSpec'.
	 */		
	public static class TypeCollectionPropertyAccessor
		implements IDataPropertyAccessor
	{
		private final DataPropertyAccessorHelper helper;
	
		public TypeCollectionPropertyAccessor(FDeployedTypeCollection target) {
			this.helper = new DataPropertyAccessorHelper(target, this);
		}
		
		
		@Override
		public IDataPropertyAccessor getOverwriteAccessor(FField obj) {
			return helper.getOverwriteAccessorAux(obj);
		}
	
		@Override
		public IDataPropertyAccessor getOverwriteAccessor(FArrayType obj) {
			return helper.getOverwriteAccessorAux(obj);
		}
	}

	/**
	 * Accessor for deployment properties for Franca interfaces according to
	 * deployment specification 'RPCSpec'.
	 */
	public static class InterfacePropertyAccessor
		implements IDataPropertyAccessor
	{
		private final MappingGenericPropertyAccessor target;
		private final DataPropertyAccessorHelper helper;
	
		public InterfacePropertyAccessor(FDeployedInterface target) {
			this.target = target;
			this.helper = new DataPropertyAccessorHelper(target, this);
		}
		
		// host 'methods'
		public Boolean getIsOptional(FMethod obj) {
			return target.getBoolean(obj, "IsOptional");
		}
		public ArgsType getArgsType(FMethod obj) {
			String e = target.getEnum(obj, "ArgsType");
			if (e==null) return null;
			return DataPropertyAccessorHelper.convertArgsType(e);
		}
			
		// host 'interfaces'
		public FInterface getOpposite(FInterface obj) {
			return target.getInterface(obj, "Opposite");
		}
		public Boolean getIsClient(FInterface obj) {
			return target.getBoolean(obj, "IsClient");
		}
			
		// host 'attributes'
		public Boolean getIsOptional(FAttribute obj) {
			return target.getBoolean(obj, "IsOptional");
		}
			
		
		/**
		 * Get an overwrite-aware accessor for deployment properties.</p>
		 *
		 * This accessor will return overwritten property values in the context 
		 * of a Franca FAttribute object. I.e., the FAttribute obj has a datatype
		 * which can be overwritten in the deployment definition (e.g., Franca array,
		 * struct, union or enumeration). The accessor will return the overwritten values.
		 * If the deployment definition didn't overwrite the value, this accessor will
		 * delegate to its parent accessor.</p>
		 *
		 * @param obj a Franca FAttribute which is the context for the accessor
		 * @return the overwrite-aware accessor
		 */
		public IDataPropertyAccessor getOverwriteAccessor(FAttribute obj) {
			return helper.getOverwriteAccessorAux(obj);
		}
	
		/**
		 * Get an overwrite-aware accessor for deployment properties.</p>
		 *
		 * This accessor will return overwritten property values in the context 
		 * of a Franca FArgument object. I.e., the FArgument obj has a datatype
		 * which can be overwritten in the deployment definition (e.g., Franca array,
		 * struct, union or enumeration). The accessor will return the overwritten values.
		 * If the deployment definition didn't overwrite the value, this accessor will
		 * delegate to its parent accessor.</p>
		 *
		 * @param obj a Franca FArgument which is the context for the accessor
		 * @return the overwrite-aware accessor
		 */
		public IDataPropertyAccessor getOverwriteAccessor(FArgument obj) {
			return helper.getOverwriteAccessorAux(obj);
		}
	
		@Override
		public IDataPropertyAccessor getOverwriteAccessor(FField obj) {
			return helper.getOverwriteAccessorAux(obj);
		}
	
		@Override
		public IDataPropertyAccessor getOverwriteAccessor(FArrayType obj) {
			return helper.getOverwriteAccessorAux(obj);
		}
	}

	/**
	 * Accessor for deployment properties for 'provider' roots
	 * (which are defined by the 'providers and instances' extension)
	 * according to the 'RPCSpec' specification.
	 */
	public static class ProviderPropertyAccessor
		implements Enums
	{
	
		public ProviderPropertyAccessor(FDeployedRootElement<FDExtensionRoot> target) {
		}
		
	}
	
	/**
	 * Accessor for getting overwritten property values.
	 */		
	public static class OverwriteAccessor
		implements IDataPropertyAccessor
	{
		private final MappingGenericPropertyAccessor target;
		private final IDataPropertyAccessor delegate;
		
		private final FDTypeOverwrites overwrites;
		private final Map<FField, FDField> mappedFields;
		private final Map<FEnumerator, FDEnumValue> mappedEnumerators;
	
		public OverwriteAccessor(
				FDTypeOverwrites overwrites,
				IDataPropertyAccessor delegate,
				MappingGenericPropertyAccessor genericAccessor)
		{
			this.target = genericAccessor;
			this.delegate = delegate;
	
			this.overwrites = overwrites;
			this.mappedFields = Maps.newHashMap();
			this.mappedEnumerators = Maps.newHashMap();
			if (overwrites!=null) {
				if (overwrites instanceof FDCompoundOverwrites) {
					// build mapping for compound fields
					for(FDField f : ((FDCompoundOverwrites)overwrites).getFields()) {
						this.mappedFields.put(f.getTarget(), f);
					}
				}
				if (overwrites instanceof FDEnumerationOverwrites) {
					// build mapping for enumerators
					for(FDEnumValue e : ((FDEnumerationOverwrites)overwrites).getEnumerators()) {
						this.mappedEnumerators.put(e.getTarget(), e);
					}
				}
			}
		}
		
		
		@Override
		public IDataPropertyAccessor getOverwriteAccessor(FField obj) {
			// check if this field is overwritten
			if (mappedFields.containsKey(obj)) {
				FDField fo = mappedFields.get(obj);
				FDTypeOverwrites overwrites = fo.getOverwrites();
				if (overwrites==null)
					return this; // TODO: correct?
				else
					// TODO: this or delegate?
					return new OverwriteAccessor(overwrites, this, target);
				
			}
			return delegate.getOverwriteAccessor(obj);
		}
	
		@Override
		public IDataPropertyAccessor getOverwriteAccessor(FArrayType obj) {
			// check if this array is overwritten
			if (overwrites!=null) {
				// TODO: this or delegate?
				return new OverwriteAccessor(overwrites, this, target);
			}
			return delegate.getOverwriteAccessor(obj);
		}
	}
}
	
