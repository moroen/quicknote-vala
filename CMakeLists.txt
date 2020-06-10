project("quicknote" C)
cmake_minimum_required(VERSION 3.2)

include(GNUInstallDirs)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

IF(APPLE)
    # Fix linking on 10.14+. See https://stackoverflow.com/questions/54068035
    LINK_DIRECTORIES(/usr/local/lib)
ENDIF()

# Check dependencies
find_package(GLib "2.38" REQUIRED)
find_package(Vala 0.48 REQUIRED)
find_package(GIO REQUIRED)
find_package(Intl REQUIRED)

find_package(PkgConfig)
set(REQUIRE_GTK "3.20")
pkg_check_modules(GTK REQUIRED gtk+-3.0>=${REQUIRE_GTK})
pkg_check_modules(CAIRO REQUIRED cairo)
pkg_check_modules(GIO REQUIRED gio-2.0>=2.42)
pkg_check_modules(GLIB2 REQUIRED glib-2.0>=2.38)
pkg_check_modules(GMODULE REQUIRED gmodule-2.0)

include_directories(${CMAKE_RUNTIME_OUTPUT_DIRECTORY})

set(CFLAGS
	${GOBJECT_CFLAGS} ${GOBJECT_CFLAGS_OTHER}
	${GIO_CFLAGS} ${GIO_CFLAGS_OTHER}
	${GTHREAD_CFLAGS} ${GTHREAD_CFLAGS_OTHER}
	${GEE_CFLAGS} ${GEE_CFLAGS_OTHER}
)
add_definitions(${CFLAGS})

set(LIBS
	${GOBJECT_LIBRARIES}
	${GIO_LIBRARIES}
	${GTHREAD_LIBRARIES}
  ${GEE_LIBRARIES}
)

link_libraries(${LIBS})

list(APPEND VALA_COMPILER_FLAGS "--target-glib=2.38")  
list(APPEND VALA_COMPILER_FLAGS "--gresources=${CMAKE_CURRENT_SOURCE_DIR}/data/resources.gresources.xml")

include(AddCompilerFlags)
global_add_compiler_flags(-Wno-incompatible-pointer-types)

vala_precompile_target(
  "${CMAKE_PROJECT_NAME}-vala"
  MY_VALA_SOURCES
  main.vala
  PACKAGES gtk+-3.0
)

glib_compile_resources("data/resources.gresources.xml"
  SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/data"
  # SOURCE "${CMAKE_CURRENT_BINARY_DIR}/resources.c"
  SOURCE "${CMAKE_PROJECT_NAME}-vala/source/resources.c"
  C_NAME "project_resources"
  INTERNAL)

message(STATUS "Currentbin: ${CMAKE_CURRENT_BINARY_DIR}")

add_executable("${CMAKE_PROJECT_NAME}"
    ${MY_VALA_SOURCES}
    "${CMAKE_PROJECT_NAME}-vala/source/resources.c"
)

add_dependencies("${CMAKE_PROJECT_NAME}" "${CMAKE_PROJECT_NAME}-vala")

# Link to libraries
target_link_libraries(${CMAKE_PROJECT_NAME}
    ${GTK_LIBRARIES})

# Add GTK+'s include directory
set_property(
    TARGET ${CMAKE_PROJECT_NAME}
    APPEND PROPERTY INCLUDE_DIRECTORIES
        ${GTK_INCLUDE_DIRS})

# Install the executable.
install (TARGETS ${CMAKE_PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})