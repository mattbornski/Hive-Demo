// Copyright (c) 2011-2012, Think Big Analytics.

package com.thinkbiganalytics.ex.hiveudfs;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.hive.ql.exec.Description;
import org.apache.hadoop.io.Text;

/**
 * A UDF that computes the moving average of the the last "numberOfUnits" of
 * the input "value" associated with the key.
 * @return the moving average for that key.
 */
@Description(name = "moving_avg",
    value = "_FUNC_(n, key, value) - Return the average of the last n values for the specified key",
    extended = "Example:\n"
    + "  > SELECT _FUNC_(50, symbol, price_close) FROM stocks LIMIT 100;\n"
    + "  25.73\n")
public final class MovingAverageUDF extends UDF {
	private Map<Text,LinkedList<Float>> map = new HashMap<Text,LinkedList<Float>>();

	public float evaluate(
			final int numberOfUnits, final Text key, final float value) {
		LinkedList<Float> list = map.get(key);
		if (list == null) {
			list = new LinkedList<Float>();
			map.put(key, list);
		}
		list.add(value);
		if (list.size() > numberOfUnits) {
			list.removeFirst();
		}
		if (numberOfUnits == 0) {
			return 0.0f;
		} else {
			int size = list.size();
			int n = size < numberOfUnits ? size : numberOfUnits;
			return sum(list) / (1.0f * n);
		}
	}

	private float sum(LinkedList<Float> list) {
		float result = 0.0F;
		for (float f: list) {
			result += f;
		}
		return result;
	}

}
