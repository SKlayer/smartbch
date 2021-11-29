export LD_LIBRARY_PATH=./
export EVMWRAP=./libevmwrap.so
cd $LD_LIBRARY_PATH
ln -s librocksdb.so.5.18.4 librocksdb.so.5.18 > /dev/null

