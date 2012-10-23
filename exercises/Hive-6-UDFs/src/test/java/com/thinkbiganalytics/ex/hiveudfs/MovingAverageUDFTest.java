package com.thinkbiganalytics.ex.hiveudfs;

import static org.junit.Assert.assertEquals;

import org.apache.hadoop.io.Text;
import org.junit.Test;

public class MovingAverageUDFTest {
	@Test
	public void zeroNumberOfUnitsShouldYieldZeroAverage() {
		MovingAverageUDF udf = new MovingAverageUDF();
		Text key = new Text("key");
		assertEquals(0.0f, udf.evaluate(0, key, 1.0f), 0.0001f);
		assertEquals(0.0f, udf.evaluate(0, key, 2.0f), 0.0001f);
		assertEquals(0.0f, udf.evaluate(0, key, 3.0f), 0.0001f);
		assertEquals(0.0f, udf.evaluate(0, key, 4.0f), 0.0001f);
	}

	@Test
	public void zeroValuesShouldYieldZeroAverage() {
		MovingAverageUDF udf = new MovingAverageUDF();
		Text key = new Text("key");
		assertEquals(0.0f, udf.evaluate(4, key, 0.0f), 0.0001f);
		assertEquals(0.0f, udf.evaluate(4, key, 0.0f), 0.0001f);
		assertEquals(0.0f, udf.evaluate(4, key, 0.0f), 0.0001f);
		assertEquals(0.0f, udf.evaluate(4, key, 0.0f), 0.0001f);
	}

	@Test
	public void emptyKeyShouldBeAccepted() {
		MovingAverageUDF udf = new MovingAverageUDF();
		Text key = new Text("");
		assertEquals(1.2f, udf.evaluate(4, key, 1.2f), 0.0001f);
		assertEquals(1.8f, udf.evaluate(4, key, 2.4f), 0.0001f);
		assertEquals(2.4f, udf.evaluate(4, key, 3.6f), 0.0001f);
		assertEquals(3.0f, udf.evaluate(4, key, 4.8f), 0.0001f);
	}

	@Test
	public void nonEmptyKeyShouldBeAccepted() {
		MovingAverageUDF udf = new MovingAverageUDF();
		Text key = new Text("x");
		assertEquals(1.2f, udf.evaluate(4, key, 1.2f), 0.0001f);
		assertEquals(1.8f, udf.evaluate(4, key, 2.4f), 0.0001f);
		assertEquals(2.4f, udf.evaluate(4, key, 3.6f), 0.0001f);
		assertEquals(3.0f, udf.evaluate(4, key, 4.8f), 0.0001f);
	}

	@Test
	public void averageShouldOnlyIncludeTheLastNValues() {
		MovingAverageUDF udf = new MovingAverageUDF();
		Text key = new Text("x");
		assertEquals(1.2f,   udf.evaluate(4, key, 1.2f), 0.0001f);
		assertEquals(1.8f,   udf.evaluate(4, key, 2.4f), 0.0001f);
		assertEquals(2.4f,   udf.evaluate(4, key, 3.6f), 0.0001f);
		assertEquals(3.0f,   udf.evaluate(4, key, 4.8f), 0.0001f);
		assertEquals(4.175f, udf.evaluate(4, key, 5.9f), 0.0001f);
		assertEquals(5.325f, udf.evaluate(4, key, 7.0f), 0.0001f);
		assertEquals(6.45f,  udf.evaluate(4, key, 8.1f), 0.0001f);
	}

	@Test
	public void averageShouldSeparateDifferentKeys() {
		MovingAverageUDF udf = new MovingAverageUDF();
		Text key1 = new Text("x1");
		Text key2 = new Text("x2");
		assertEquals(1.2f,    udf.evaluate(4, key1, 1.2f), 0.0001f);
		assertEquals(0.2f,    udf.evaluate(3, key2, 0.2f), 0.0001f);
		assertEquals(1.8f,    udf.evaluate(4, key1, 2.4f), 0.0001f);
		assertEquals(0.25f,   udf.evaluate(3, key2, 0.3f), 0.0001f);
		assertEquals(2.4f,    udf.evaluate(4, key1, 3.6f), 0.0001f);
		assertEquals(0.3333f, udf.evaluate(3, key2, 0.5f), 0.0001f);
		assertEquals(3.0f,    udf.evaluate(4, key1, 4.8f), 0.0001f);
		assertEquals(0.5f,    udf.evaluate(3, key2, 0.7f), 0.0001f);
		assertEquals(4.175f,  udf.evaluate(4, key1, 5.9f), 0.0001f);
		assertEquals(0.6667f, udf.evaluate(3, key2, 0.8f), 0.0001f);
		assertEquals(5.325f,  udf.evaluate(4, key1, 7.0f), 0.0001f);
		assertEquals(0.8f,    udf.evaluate(3, key2, 0.9f), 0.0001f);
		assertEquals(6.45f,   udf.evaluate(4, key1, 8.1f), 0.0001f);
		assertEquals(0.9f,    udf.evaluate(3, key2, 1.0f), 0.0001f);
	}
}
