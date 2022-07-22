# Troubles in Gem5

## undefined reference to create() const

Take `DummyDecoder` for example.
`DummyDecoder` derives from `InstDecoder`.

### Reason

TODO:

The declaration and definition of `create()` is
build/X86/params/DummyDecoder.hh,
build/X86/python/_m5/param_DummyDecoder.cc.

TODO: is_constructible_v

### Case1: Undefined pure virtual function

If there are undefined pure virtual funtions in cpp simobject, like

```cpp
class DummyDecoder : public InstDecoder
{
  public:
    DummyDecoder(const DummyDecoderParams &p) :
        InstDecoder(p, (uint64_t *)NULL)
    {}
};
```

The following two functions are pure virtual function in InstDecoder.

```cpp
class InstDecoder : public SimObject
{
  ...
  void moreBytes(const PCStateBase &pc, Addr fetchPC) = 0;
  StaticInstPtr decode(PCStateBase &pc) = 0;
  ...
}
```

If not define them in DummyDecoder,
compiler (gcc) won't throw error at compile time,
`undefined reference to create() const` will pop out at link time.
