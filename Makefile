SRC = $(wildcard *.s)
OBJS = $(SRC:.s=.o)

TARGET = rom.gbc

$(TARGET): $(OBJS) linkfile
	wlalink linkfile rom.gbc
	rgbfix -Cv rom.gbc

%.o: ../Ages*Hack.gbc %.s
	wla-gb -o $*.s
	
linkfile: $(OBJS)
	echo "[objects]" > linkfile
	echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

-include $(SRC:.s=.d)

.PHONY: clean run

clean:
	-rm *.o *.d $(TARGET)

run:
	/c/Users/Matthew/Desktop/Things/Emulators/bgb/bgb.exe $(TARGET)
