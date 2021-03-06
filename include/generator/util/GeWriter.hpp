#ifndef __VESYLA_GENERATOR_GE_WRITER_HPP__
#define __VESYLA_GENERATOR_GE_WRITER_HPP__

#include <iostream>
#include <fstream>
#include "util/Common.hpp"

using namespace std;

namespace vesyla{
namespace generator{

class GeWriter{
public:
	GeWriter(string filename);
	~GeWriter();
	void write_line(string line);
	void inc_tab();
	void dec_tab();
	int depth();

private:
	ofstream _f;
	int _depth;

};

}
}


#endif // __VESYLA_GENERATOR_GE_WRITER_HPP__
