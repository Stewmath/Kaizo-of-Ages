OBJS = main.o text.o

TARGET = rom.gbc

$(TARGET): $(OBJS) linkfile
	wlalink linkfile rom.gbc
	rgbfix -Cv rom.gbc

# ../Ages*Hack.gbc $(wildcard *.s) $(wildcard include/*.s)
%.o: %.s $(wildcard *.s) $(wildcard include/*.s) ../Ages_Hack.gbc
	echo $@
	wla-gb -o $(basename $@).s
	
linkfile: $(OBJS)
	echo "[objects]" > linkfile
	echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

.PHONY: clean run

clean:
	-rm *.o $(TARGET)

run:
	/c/Users/Matthew/Desktop/Things/Emulators/bgb/bgb.exe $(TARGET)
