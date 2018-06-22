readme_tools.txt

Created: 12/12/2017

The "Tools" folder contains a variety of MATLAB functions that can be used to assist in thermal
modeling and analysis. Below is a list of the tools with a short description.

LIST OF TOOLS:

	- CubicSpline.m: returns the coefficients of all the cubic splines connecting points in
		a given data set.

	- CubicSplineInterp.m: uses the cubic spline coefficient produced by "CubicSpline.m" to
		interpolate or return the first, second, or third derivative at any x-value(s) 
		along the span of the original data set. 

	- digitizeImage.m: an interactive function that can be used to extract data from images. 

	- extendLine.m: this function will append a data set with an additional point to extend the
		a line to the presribed value through linear or cubic spline extrapolation. 

	- lineOffset.m: this function will offset a line above, below, or in both directions. 
	
	- ReduceDataSet.m: reduces a data set to be more consistent with the prescribed interval of
		the independent variable. For example, if time-dependent data is recorded at a rate
		that is much faster than is necessary for your application, this function can be used
		to reduce the data set to a more appropriate time interval.

	- ThermExp1DElastic.m: Models 1D elastic thermal expansion of an object.

	- trimLine.m:  this function will truncate and append a data set with an additional point
		to trim a line to the prescribed value.

	- PolyProd.m: given the coefficient of 2 polynomials, it returns the coefficients of the
		product of the 2 polynomials.

	- PolySum.m: given the coefficient of 2 polynomials, it returns the coefficients of the
		sum of the 2 polynomials.

The use of each of these tools is illustrated within and example scripts inside the "Examples"
folder