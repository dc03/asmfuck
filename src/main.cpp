#include <fstream>
#include <iostream>
#include <iterator>
#include <string>

extern "C" int interp_main(const char *insts);

int main(int argc, char **argv) {
    std::string file{};
    if (argc < 2) {
        std::cout << "Brainfuck file: ";
        std::cin >> file;
    } else {
        file = argv[1];
    }

    std::ifstream contents{file, std::ios::in};
    if (not contents.is_open()) {
        std::cout << "bruh\n";
        return -1;
    }

    std::string insts{std::istream_iterator<char>(contents), std::istream_iterator<char>()};
    interp_main(insts.data());
}