set CMAKE_CONFIG=Release
if errorlevel 1 exit 1

mkdir build_%CMAKE_CONFIG%
if errorlevel 1 exit 1

cd build_%CMAKE_CONFIG%
if errorlevel 1 exit 1

cmake -G "NMake Makefiles" ^
      -DCMAKE_BUILD_TYPE:STRING=%CMAKE_CONFIG% ^
      -DBUILD_SHARED_LIBS:BOOL=ON ^
      -DBUILD_STATIC_LIBS:BOOL=ON ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      "%SRC_DIR%"
if errorlevel 1 exit 1

ctest
if errorlevel 1 exit 1

cmake --build . --target install --config %CMAKE_CONFIG%
if errorlevel 1 exit 1
