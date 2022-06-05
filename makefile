SDK_PATH = $(shell xcrun --show-sdk-path -sdk macosx)
SWIFT_PATH = $(shell xcrun --show-sdk-path)/usr/lib/swift
TOOLCHAIN_PATH = $(shell xcode-select --print-path)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx

SWF_C_ARGS = -sdk $(SDK_PATH)
LD_ARGS = -syslibroot $(SDK_PATH) -lSystem -arch arm64 -L $(TOOLCHAIN_PATH) -L $(SWIFT_PATH)

main: main.o A.o B.o
	ld main.o A.o B.o $(LD_ARGS) -o main.out

A.o: A.swift
	swiftc -frontend -c main.swift -primary-file A.swift -module-name Foo -o A.o $(SWF_C_ARGS)

B.o: B.swift
	swiftc -frontend -c main.swift -primary-file B.swift -module-name Foo -o B.o $(SWF_C_ARGS)

main.o: main.swift
	swiftc -frontend -c A.swift B.swift -primary-file main.swift -module-name Foo -o main.o $(SWF_C_ARGS)

clean:
	rm *.o *.out