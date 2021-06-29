```bash
zig build-lib -dynamic -O ReleaseFast partitions.zig --library c
gnatmake outcomes.adb -largs -ldl
```
