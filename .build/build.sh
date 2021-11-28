cd ~
rm -rf ./smartbch_build/
mkdir ./smartbch_build/

rm -rf ./smartbch_out/
mkdir ./smartbch_out/

export BUILDDIR=~/smartbch_build
export FINDIR=~/smartbch_out


sudo apt install make cmake git -y
sudo apt install gcc-8 g++-8 -y
sudo apt install libgflags-dev zlib1g-dev libbz2-dev liblz4-dev libzstd-dev -y
sudo apt install libsnappy-dev -y

cd $BUILDDIR
wget https://golang.org/dl/go1.16.5.linux-amd64.tar.gz
tar zxvf go1.16.5.linux-amd64.tar.gz

export GOROOT=$BUILDDIR/go
export PATH=$PATH:$GOROOT/bin
mkdir $BUILDDIR/godata
export GOPATH=$BUILDDIR/godata

wget https://github.com/smartbch/patch-cgo-for-golang/archive/refs/tags/v0.1.1.tar.gz
tar zxvf v0.1.1.tar.gz 
rm v0.1.1.tar.gz

cp $BUILDDIR/patch-cgo-for-golang-0.1.1/*.c $GOROOT/src/runtime/cgo/

# build the snappy
cd $BUILDDIR/
wget https://github.com/google/snappy/archive/refs/tags/1.1.8.tar.gz
tar zxvf 1.1.8.tar.gz
cd snappy-1.1.8
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=On ../
make -j8
sudo make install

cd $BUILDDIR/
wget https://github.com/facebook/rocksdb/archive/refs/tags/v5.18.4.tar.gz
tar zxvf v5.18.4.tar.gz
cd rocksdb-5.18.4
make CC=gcc-8 CXX=g++-8 shared_lib -j8


export ROCKSDB_PATH="$BUILDDIR/rocksdb-5.18.4" ;#this direct to rocksdb root dir
export CGO_CFLAGS="-I/$ROCKSDB_PATH/include"
export CGO_LDFLAGS="-L/$ROCKSDB_PATH -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4 -lzstd"
export LD_LIBRARY_PATH=$ROCKSDB_PATH:/usr/local/lib


cd $BUILDDIR
mkdir smart_bch
cd smart_bch
git clone --depth 1 https://github.com/smartbch/moeingevm
cd moeingevm/evmwrap
make
export EVMWRAP=$BUILDDIR/smart_bch/moeingevm/evmwrap/host_bridge/libevmwrap.so

cd $BUILDDIR/smart_bch
git clone --depth 1 https://github.com/smartbch/smartbch
cd smartbch
go build -tags cppbtree github.com/smartbch/smartbch/cmd/smartbchd


mv $BUILDDIR/smart_bch/smartbch/smartbchd $FINDIR/
mv $BUILDDIR/rocksdb-5.18.4/librocksdb.so.5.18.4 $FINDIR/
mv $BUILDDIR/smart_bch/moeingevm/evmwrap/host_bridge/libevmwrap.so $FINDIR/
rm -rf $BUILDDIR


