# Copyright: 2018 Antti Kamppi

# Print a separator to create cleaner outputs between sections
function(print_divisor)
    message(STATUS "******************************************************************************")
endfunction(print_divisor)

# Print the property value of a given target
#
# Usage: print_target_property(<target name> <property name>)
function(print_target_property target_name property_name)
    get_property(target_value TARGET ${target_name} PROPERTY ${property_name})
    message("Target='${target_name}' property='${property_name}'")
    message("   value='${target_value}'")
endfunction(print_target_property)

# Print given properties of specified target
#
# Usage: print_properties(<target name> [property1] [property2]...)
function(print_properties target_name)
    print_divisor()
    set(_tgt_name ${target_name})
    message(STATUS "Target: ${target_name}")
    
    set(_PROPERTIES ${ARGN})
    foreach(_PROP ${_PROPERTIES})
        get_property(_target_value TARGET ${_tgt_name} PROPERTY ${_PROP})
        message(STATUS "   ${_PROP}: ")
        
        foreach(_value ${_target_value})
            message(STATUS "      ${_value}")
        endforeach()
    endforeach()
endfunction(print_properties)

# Print a list of items with each one in a separate line
function(print_list list)
    foreach(_item ${list})
        message(STATUS "${_item}")
    endforeach()
endfunction(print_list)

# Print properties of given targets
# 
# Note: The properties to print are fixed
# Usage: print_all_target_properties(<list of target names>)
function(print_all_target_properties TARGET_NAMES)
    foreach(_TARGET_NAME ${TARGET_NAMES})
        print_properties(${_TARGET_NAME} COMPILE_FLAGS LINK_FLAGS INCLUDE_DIRECTORIES RUNTIME_OUTPUT_DIRECTORY ARCHIVE_OUTPUT_DIRECTORY SOURCES)
    
        get_property(_LINK_LIBRARIES GLOBAL
            PROPERTY ${_TARGET_NAME}_LINK_LIBRARIES   
        )
        
        message(STATUS "   LINK_LIBRARIES:")
        foreach(_LIBRARY ${_LINK_LIBRARIES})
            message(STATUS "      ${_LIBRARY}")
        endforeach()
        print_divisor()
        
    endforeach()
        
endfunction(print_all_target_properties)
