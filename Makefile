SRC = main.s
OBJS = main.o

TARGET = rom.gbc

$(TARGET): $(OBJS) linkfile
	wlalink linkfile rom.gbc
	rgbfix -Cv rom.gbc

main.o: ../Ages*Hack.gbc $(wildcard *.s)
	echo $*
	wla-gb -o main.s
	
linkfile: $(OBJS)
	echo "[objects]" > linkfile
	echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

.PHONY: clean run

clean:
	-rm *.o *.d $(TARGET)

run:
	/c/Users/Matthew/Desktop/Things/Emulators/bgb/bgb.exe $(TARGET)
