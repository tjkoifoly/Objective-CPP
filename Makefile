DIR_BUILD                = ./Build/
DIR_BUILD_TMP            = $(DIR_BUILD)Temp/
DIR_BUILD_TMP_CLASSES    = $(DIR_BUILD_TMP)Classes/
DIR_BUILD_TMP_CATEGORIES = $(DIR_BUILD_TMP)Categories/
DIR_BUILD_RELEASE        = $(DIR_BUILD)Release/
DIR_BUILD_TEST           = $(DIR_BUILD)Test/
DIR_SRC	                 = ./Source/
DIR_SRC_CLASSES          = $(DIR_SRC)Classes/
DIR_SRC_CATEGORIES       = $(DIR_SRC)Categories/
DIR_INC	                 = $(DIR_SRC)
DIR_INC_CLASSES          = $(DIR_SRC_CLASSES)
DIR_INC_CATEGORIES       = $(DIR_SRC_CATEGORIES)

EXT_CODE        = .mm
EXT_HEADERS     = .h
EXT_OBJECT      = .o
EXT_LIB_OBJECT  = .lo
EXT_LIB_ARCHIVE = .la
EXT_ARCHIVE     = .a

PRODUCT_NAME = libobjc-cpp

CC              = g++
RM              = rm
LIBTOOL         = glibtool
LIBTOOL_DYNAMIC = libtool

ARGS_RM             = -rf
ARGS_CC             = -Os -pedantic -Werror -Wall -Wextra -Wmissing-braces -Wmissing-field-initializers -Wmissing-prototypes -Wparentheses -Wreturn-type -Wshadow -Wsign-compare -Wswitch -Wuninitialized -Wunknown-pragmas -Wunused-function -Wunused-label -Wunused-parameter -Wunused-value -Wunused-variable
ARGS_LIBTOOL_LO     = --mode=compile
ARGS_LIBTOOL_LA     = --mode=link
ARGS_LIBTOOL        = --quiet

.SUFFIXES:
.SUFFIXES: $(EXT_CODE) $(EXT_HEADERS) $(EXT_OBJECT)

VPATH =
vpath
vpath %$(EXT_CODE) $(DIR_SRC)
vpath %$(EXT_CODE) $(DIR_SRC_CLASSES)
vpath %$(EXT_CODE) $(DIR_SRC_CATEGORIES)
vpath %$(EXT_HEADERS) $(DIR_SRC)
vpath %$(EXT_HEADERS) $(DIR_SRC_CLASSES)
vpath %$(EXT_HEADERS) $(DIR_SRC_CATEGORIES)
vpath %$(EXT_OBJECT) $(DIR_BUILD_TMP)

_FILES_SRC          = $(foreach dir,$(DIR_SRC),$(wildcard $(DIR_SRC)*$(EXT_CODE)))
_FILES_SRC_REL      = $(notdir $(_FILES_SRC))
_FILES_SRC_O        = $(subst $(EXT_CODE),$(EXT_OBJECT),$(_FILES_SRC_REL))
_FILES_SRC_O_BUILD  = $(addprefix $(DIR_BUILD_TMP),$(_FILES_SRC_O))

_FILES_SRC_CLASSES          = $(foreach dir,$(DIR_SRC_CLASSES),$(wildcard $(DIR_SRC_CLASSES)*$(EXT_CODE)))
_FILES_SRC_CLASSES_REL      = $(notdir $(_FILES_SRC_CLASSES))
_FILES_SRC_CLASSES_O        = $(subst $(EXT_CODE),$(EXT_OBJECT),$(_FILES_SRC_CLASSES_REL))
_FILES_SRC_CLASSES_O_BUILD  = $(addprefix $(DIR_BUILD_TMP_CLASSES),$(_FILES_SRC_CLASSES_O))

_FILES_SRC_CATEGORIES          = $(foreach dir,$(DIR_SRC_CATEGORIES),$(wildcard $(DIR_SRC_CATEGORIES)*$(EXT_CODE)))
_FILES_SRC_CATEGORIES_REL      = $(notdir $(_FILES_SRC_CATEGORIES))
_FILES_SRC_CATEGORIES_O        = $(subst $(EXT_CODE),$(EXT_OBJECT),$(_FILES_SRC_CATEGORIES_REL))
_FILES_SRC_CATEGORIES_O_BUILD  = $(addprefix $(DIR_BUILD_TMP_CATEGORIES),$(_FILES_SRC_CATEGORIES_O))

_ARGS_CC = -I $(DIR_INC) -I $(DIR_INC_CLASSES) -I $(DIR_INC_CATEGORIES) $(ARGS_CC)

.PHONY: clean all main test lib objects

all: objects main lib

objects: $(_FILES_SRC_O_BUILD) $(_FILES_SRC_CLASSES_O_BUILD) $(_FILES_SRC_CATEGORIES_O_BUILD)

test: main
	@$(DIR_BUILD_TEST)main
	
main: objects
	@$(CC) $(_ARGS_CC) -framework Foundation -o $(DIR_BUILD_TEST)main $(_FILES_SRC_O_BUILD) $(_FILES_SRC_CLASSES_O_BUILD) $(_FILES_SRC_CATEGORIES_O_BUILD)

lib:
	@echo "    - Building library object:  "$(PRODUCT_NAME)$(EXT_LIB_OBJECT)
	$(LIBTOOL) $(ARGS_LIBTOOL) $(ARGS_LIBTOOL_LO) $(CC) -o $(DIR_BUILD_TMP)$(PRODUCT_NAME)$(EXT_LIB_OBJECT) -c $(_FILES_SRC_CLASSES_O_BUILD) $(_FILES_SRC_CATEGORIES_O_BUILD) $(_ARGS_CC) $(CFLAGS) -framework Foundation
	@echo "    - Building static library:  "$(PRODUCT_NAME)$(EXT_LIB_ARCHIVE)
	$(LIBTOOL) $(ARGS_LIBTOOL) $(ARGS_LIBTOOL_LA) $(CC) -o $(PRODUCT_NAME)$(EXT_LIB_ARCHIVE) -c $(PRODUCT_NAME)$(EXT_LIB_OBJECT) $(_ARGS_CC) $(CFLAGS)
	@cp $(subst $(DIR_BUILD),$(DIR_BUILD).libs/,$(subst $(EXT_LIB_ARCHIVE),$(EXT_ARCHIVE),$@)) $(subst $(EXT_LIB_ARCHIVE),$(EXT_ARCHIVE),$@)
	
clean:
	@echo "    *** Cleaning all build files..."
	@$(RM) $(ARGS_RM) $(DIR_BUILD_TMP)*$(EXT_OBJECT)
	@$(RM) $(ARGS_RM) $(DIR_BUILD_TMP)*$(EXT_LIB_OBJECT)
	@$(RM) $(ARGS_RM) $(DIR_BUILD_TMP)*$(EXT_LIB_ARCHIVE)
	@$(RM) $(ARGS_RM) $(DIR_BUILD_TMP_CLASSES)*$(EXT_OBJECT)
	@$(RM) $(ARGS_RM) $(DIR_BUILD_TMP_CATEGORIES)*$(EXT_OBJECT)
	@$(RM) $(ARGS_RM) $(DIR_BUILD_RELEASE)*
	@$(RM) $(ARGS_RM) $(DIR_BUILD_TEST)*
	
$(DIR_BUILD_TMP_CATEGORIES)%$(EXT_OBJECT): $(DIR_SRC_CATEGORIES)%$(EXT_CODE)
	@echo "    - Building object file:     "$(subst $(DIR_BUILD_TMP_CATEGORIES),"",$@)
	@$(CC) $(_ARGS_CC) -o $(DIR_BUILD_TMP_CATEGORIES)$(@F) -c $< $(CFLAGS)
	
$(DIR_BUILD_TMP_CLASSES)%$(EXT_OBJECT): $(DIR_SRC_CLASSES)%$(EXT_CODE)
	@echo "    - Building object file:     "$(subst $(DIR_BUILD_TMP_CLASSES),"",$@)
	@$(CC) $(_ARGS_CC) -o $(DIR_BUILD_TMP_CLASSES)$(@F) -c $< $(CFLAGS)
	
$(DIR_BUILD_TMP)%$(EXT_OBJECT): $(DIR_SRC)%$(EXT_CODE)
	@echo "    - Building object file:     "$(subst $(DIR_BUILD_TMP),"",$@)
	@$(CC) $(_ARGS_CC) -o $(DIR_BUILD_TMP)$(@F) -c $< $(CFLAGS)
